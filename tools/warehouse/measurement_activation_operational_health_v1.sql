-- CEFA measurement activation operational health v1.
--
-- Additive monitoring only. This script does not enable a poller, dispatcher,
-- platform send, campaign goal, or website conversion. The run table contains
-- aggregate operational counts only; raw identifiers, payloads, contact data,
-- and free-text errors are prohibited.

CREATE TABLE IF NOT EXISTS `marketing-api-488017.cefa_ops.measurement_pipeline_run_v1` (
  run_id STRING NOT NULL,
  pipeline_key STRING NOT NULL,
  site_context STRING NOT NULL,
  source_system STRING NOT NULL,
  destination_system STRING,
  runtime_mode STRING NOT NULL,
  started_at TIMESTAMP NOT NULL,
  finished_at TIMESTAMP,
  run_status STRING NOT NULL,
  records_read INT64 NOT NULL,
  records_loaded INT64 NOT NULL,
  records_quarantined INT64 NOT NULL,
  records_rejected INT64 NOT NULL,
  latest_source_event_at TIMESTAMP,
  error_code STRING,
  created_at TIMESTAMP NOT NULL
)
PARTITION BY DATE(started_at)
CLUSTER BY site_context, pipeline_key, run_status
OPTIONS (
  description = 'Aggregate-only CEFA measurement pipeline run audit. No row identifiers, raw PII, payloads, or free-text errors.'
);

CREATE OR REPLACE VIEW `marketing-api-488017.cefa_ops.vw_measurement_activation_health_v1`
OPTIONS (
  description = 'Aggregate-only v1 health scorecard for CEFA measurement and secondary outcome activation.'
)
AS
WITH pipeline_config AS (
  SELECT *
  FROM UNNEST([
    STRUCT('parent' AS site_context, 'parent_form4_capture' AS pipeline_key, 5 AS expected_cadence_minutes, TRUE AS active, 'CEFA marketing measurement' AS owner_role),
    STRUCT('parent', 'parent_identity_binder', 15, FALSE, 'CEFA marketing measurement'),
    STRUCT('parent', 'parent_lifecycle_poller', 15, FALSE, 'CEFA marketing measurement'),
    STRUCT('parent', 'parent_google_delivery', 5, FALSE, 'CEFA marketing measurement'),
    STRUCT('parent', 'parent_meta_delivery', 5, FALSE, 'CEFA marketing measurement'),
    STRUCT('franchise_ca', 'franchise_ca_outcome_activation', 1440, FALSE, 'CEFA marketing measurement'),
    STRUCT('franchise_usa', 'franchise_usa_outcome_activation', 1440, FALSE, 'CEFA marketing measurement')
  ])
),
latest_run AS (
  SELECT * EXCEPT(row_number)
  FROM (
    SELECT
      run.*,
      ROW_NUMBER() OVER (
        PARTITION BY site_context, pipeline_key
        ORDER BY started_at DESC, created_at DESC
      ) AS row_number
    FROM `marketing-api-488017.cefa_ops.measurement_pipeline_run_v1` AS run
  )
  WHERE row_number = 1
),
latest_success AS (
  SELECT
    site_context,
    pipeline_key,
    MAX(finished_at) AS last_success_at,
    MAX(latest_source_event_at) AS latest_source_event_at
  FROM `marketing-api-488017.cefa_ops.measurement_pipeline_run_v1`
  WHERE run_status = 'succeeded'
  GROUP BY site_context, pipeline_key
),
pipeline_freshness AS (
  SELECT
    CURRENT_TIMESTAMP() AS observed_at,
    config.site_context,
    config.pipeline_key AS component,
    'last_successful_sync' AS metric_key,
    CASE
      WHEN NOT config.active THEN 'NOT_ACTIVE'
      WHEN success.last_success_at IS NULL THEN 'NOT_INSTRUMENTED'
      WHEN TIMESTAMP_DIFF(CURRENT_TIMESTAMP(), success.last_success_at, MINUTE)
        <= CAST(CEIL(config.expected_cadence_minutes * 1.25) AS INT64) THEN 'GREEN'
      WHEN TIMESTAMP_DIFF(CURRENT_TIMESTAMP(), success.last_success_at, MINUTE)
        <= CAST(CEIL(config.expected_cadence_minutes * 1.5) AS INT64) THEN 'AMBER'
      ELSE 'RED'
    END AS health_status,
    CAST(TIMESTAMP_DIFF(CURRENT_TIMESTAMP(), success.last_success_at, MINUTE) AS FLOAT64) AS current_value,
    FORMAT(
      'GREEN <= %d minutes; AMBER <= %d minutes; RED above that',
      CAST(CEIL(config.expected_cadence_minutes * 1.25) AS INT64),
      CAST(CEIL(config.expected_cadence_minutes * 1.5) AS INT64)
    ) AS threshold_definition,
    success.last_success_at AS evidence_timestamp,
    config.owner_role,
    'Run the pipeline-failure runbook; keep business forms live and stop only affected downstream delivery.' AS breach_action,
    FORMAT(
      'expected cadence=%d minutes; latest source event=%s',
      config.expected_cadence_minutes,
      COALESCE(CAST(success.latest_source_event_at AS STRING), 'not recorded')
    ) AS details
  FROM pipeline_config AS config
  LEFT JOIN latest_success AS success
    USING (site_context, pipeline_key)
),
pipeline_reconciliation AS (
  SELECT
    CURRENT_TIMESTAMP() AS observed_at,
    config.site_context,
    config.pipeline_key AS component,
    'records_reconciled' AS metric_key,
    CASE
      WHEN NOT config.active THEN 'NOT_ACTIVE'
      WHEN latest.run_id IS NULL THEN 'NOT_INSTRUMENTED'
      WHEN latest.run_status = 'failed' THEN 'RED'
      WHEN latest.records_read - latest.records_loaded - latest.records_quarantined - latest.records_rejected = 0 THEN 'GREEN'
      ELSE 'RED'
    END AS health_status,
    CAST(
      latest.records_read - latest.records_loaded - latest.records_quarantined - latest.records_rejected
      AS FLOAT64
    ) AS current_value,
    'GREEN only when read = loaded + quarantined + rejected' AS threshold_definition,
    latest.finished_at AS evidence_timestamp,
    config.owner_role,
    'Run the data-quality runbook; preserve the source records and do not replay until the difference is zero.' AS breach_action,
    FORMAT(
      'read=%d loaded=%d quarantined=%d rejected=%d status=%s',
      latest.records_read,
      latest.records_loaded,
      latest.records_quarantined,
      latest.records_rejected,
      latest.run_status
    ) AS details
  FROM pipeline_config AS config
  LEFT JOIN latest_run AS latest
    USING (site_context, pipeline_key)
),
missing_id_stats AS (
  SELECT
    COUNTIF(NOT is_initial_baseline) AS prospective_rows,
    COUNTIF(
      NOT is_initial_baseline
      AND (form4_event_id IS NULL OR form4_event_id = '' OR form_entry_id IS NULL OR form_entry_id = '')
    ) AS missing_id_rows,
    COUNTIF(
      NOT is_initial_baseline
      AND (form4_event_id IS NULL OR form4_event_id = '' OR form_entry_id IS NULL OR form_entry_id = '')
      AND quarantine_status != 'quarantined'
    ) AS unsafe_missing_id_rows,
    MAX(created_at) AS latest_at
  FROM `marketing-api-488017.cefa_parent_activation_restricted.parent_crm_lifecycle_event`
),
missing_id_health AS (
  SELECT
    CURRENT_TIMESTAMP() AS observed_at,
    'parent' AS site_context,
    'parent_identity_and_lifecycle' AS component,
    'missing_cefa_ids' AS metric_key,
    CASE
      WHEN prospective_rows = 0 THEN 'NOT_ACTIVE'
      WHEN unsafe_missing_id_rows > 0 THEN 'RED'
      WHEN missing_id_rows > 0 THEN 'AMBER'
      ELSE 'GREEN'
    END AS health_status,
    CAST(missing_id_rows AS FLOAT64) AS current_value,
    'GREEN = 0; AMBER only when every affected record is quarantined; RED if any affected record is not quarantined' AS threshold_definition,
    latest_at AS evidence_timestamp,
    'CEFA marketing measurement' AS owner_role,
    'Run the data-quality runbook; quarantine only the affected records and verify exact event and form-entry identity.' AS breach_action,
    FORMAT(
      'prospective rows=%d; missing IDs=%d; unsafe missing IDs=%d',
      prospective_rows,
      missing_id_rows,
      unsafe_missing_id_rows
    ) AS details
  FROM missing_id_stats
),
duplicate_groups AS (
  SELECT
    transaction_id,
    COUNT(*) AS row_count,
    COUNTIF(accepted_at IS NOT NULL) AS accepted_count,
    MAX(updated_at) AS latest_at
  FROM `marketing-api-488017.cefa_parent_activation_restricted.parent_conversion_outbox`
  GROUP BY transaction_id
  HAVING COUNT(*) > 1
),
duplicate_stats AS (
  SELECT
    (SELECT COUNT(*) FROM `marketing-api-488017.cefa_parent_activation_restricted.parent_conversion_outbox`) AS outbox_rows,
    COUNT(*) AS duplicate_group_count,
    COUNTIF(accepted_count > 1) AS accepted_duplicate_group_count,
    MAX(latest_at) AS latest_at
  FROM duplicate_groups
),
duplicate_health AS (
  SELECT
    CURRENT_TIMESTAMP() AS observed_at,
    'parent' AS site_context,
    'parent_conversion_outbox' AS component,
    'duplicate_transactions' AS metric_key,
    CASE
      WHEN outbox_rows = 0 THEN 'NOT_ACTIVE'
      WHEN duplicate_group_count = 0 THEN 'GREEN'
      ELSE 'RED'
    END AS health_status,
    CAST(duplicate_group_count AS FLOAT64) AS current_value,
    'GREEN = 0 duplicate transaction groups; any accepted duplicate is an immediate stop condition' AS threshold_definition,
    latest_at AS evidence_timestamp,
    'CEFA marketing measurement' AS owner_role,
    'Activate the dispatcher kill switch and run the data-quality runbook before any replay.' AS breach_action,
    FORMAT(
      'outbox=%d; duplicate groups=%d; accepted duplicate groups=%d; retry attempts are not counted as duplicate transactions',
      outbox_rows,
      duplicate_group_count,
      accepted_duplicate_group_count
    ) AS details
  FROM duplicate_stats
),
platform_config AS (
  SELECT
    'google' AS platform,
    'parent_google_delivery' AS component,
    'google_delivery_status' AS metric_key
  UNION ALL
  SELECT
    'meta',
    'parent_meta_delivery',
    'meta_delivery_status'
),
platform_stats AS (
  SELECT
    config.platform,
    config.component,
    config.metric_key,
    COUNT(outbox.outbox_id) AS outbox_rows,
    COUNTIF(outbox.delivery_status = 'accepted') AS accepted_rows,
    COUNTIF(outbox.delivery_status = 'permanent_failure') AS permanent_failure_rows,
    COUNTIF(outbox.delivery_status = 'retryable_failure') AS retryable_failure_rows,
    COUNTIF(
      outbox.delivery_status IN ('processing', 'leased')
      AND outbox.updated_at < TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 24 HOUR)
    ) AS stale_processing_rows,
    COUNTIF(
      outbox.delivery_status = 'queued'
      AND outbox.created_at < TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 24 HOUR)
    ) AS stale_queued_rows,
    MAX(outbox.updated_at) AS latest_at
  FROM platform_config AS config
  LEFT JOIN `marketing-api-488017.cefa_parent_activation_restricted.parent_conversion_outbox` AS outbox
    ON LOWER(outbox.platform) = config.platform
  GROUP BY config.platform, config.component, config.metric_key
),
platform_health AS (
  SELECT
    CURRENT_TIMESTAMP() AS observed_at,
    'parent' AS site_context,
    component,
    metric_key,
    CASE
      WHEN outbox_rows = 0 THEN 'NOT_ACTIVE'
      WHEN permanent_failure_rows > 0 OR stale_processing_rows > 0 THEN 'RED'
      WHEN retryable_failure_rows > 0 OR stale_queued_rows > 0 THEN 'AMBER'
      ELSE 'GREEN'
    END AS health_status,
    CAST(permanent_failure_rows + retryable_failure_rows + stale_processing_rows + stale_queued_rows AS FLOAT64) AS current_value,
    'GREEN = no permanent/retryable failure and no row pending over 24 hours; RED for permanent failure or stale processing' AS threshold_definition,
    latest_at AS evidence_timestamp,
    'CEFA marketing measurement' AS owner_role,
    'Run the platform-delivery-failure runbook; stop only the affected platform unless a global stop condition exists.' AS breach_action,
    FORMAT(
      'outbox=%d accepted=%d permanent=%d retryable=%d stale_processing=%d stale_queued=%d',
      outbox_rows,
      accepted_rows,
      permanent_failure_rows,
      retryable_failure_rows,
      stale_processing_rows,
      stale_queued_rows
    ) AS details
  FROM platform_stats
),
actionable_quarantine AS (
  SELECT
    COALESCE(quarantine_reason, 'unspecified') AS quarantine_reason,
    updated_at AS quarantined_at
  FROM `marketing-api-488017.cefa_parent_activation_restricted.parent_form4_identity_inbox`
  WHERE bridge_status = 'quarantined'

  UNION ALL

  SELECT
    COALESCE(quarantine_reason, 'unspecified') AS quarantine_reason,
    created_at AS quarantined_at
  FROM `marketing-api-488017.cefa_parent_activation_restricted.parent_crm_lifecycle_event`
  WHERE quarantine_status = 'quarantined'
    AND COALESCE(quarantine_reason, '') NOT IN (
      'baseline_non_uploadable',
      'non_uploadable_stage',
      'first_positive_occurrence_already_sent',
      'multi_school_fanout_collapsed',
      'test_record'
    )
),
quarantine_stats AS (
  SELECT
    COUNT(*) AS quarantine_rows,
    MIN(quarantined_at) AS oldest_quarantine_at,
    MAX(quarantined_at) AS latest_quarantine_at
  FROM actionable_quarantine
),
quarantine_health AS (
  SELECT
    CURRENT_TIMESTAMP() AS observed_at,
    'parent' AS site_context,
    'parent_identity_and_lifecycle' AS component,
    'records_currently_in_quarantine' AS metric_key,
    CASE
      WHEN quarantine_rows = 0 THEN 'GREEN'
      WHEN oldest_quarantine_at < TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 168 HOUR) THEN 'RED'
      ELSE 'AMBER'
    END AS health_status,
    CAST(quarantine_rows AS FLOAT64) AS current_value,
    'GREEN = 0 actionable rows; AMBER when contained under 7 days; RED when the oldest actionable row exceeds 7 days' AS threshold_definition,
    latest_quarantine_at AS evidence_timestamp,
    'CEFA marketing measurement' AS owner_role,
    'Run the data-quality runbook; resolve or retain each reason explicitly and never release an unsafe record.' AS breach_action,
    FORMAT('actionable quarantine rows=%d; oldest=%s', quarantine_rows, COALESCE(CAST(oldest_quarantine_at AS STRING), 'none')) AS details
  FROM quarantine_stats
)
SELECT * FROM pipeline_freshness
UNION ALL
SELECT * FROM pipeline_reconciliation
UNION ALL
SELECT * FROM missing_id_health
UNION ALL
SELECT * FROM duplicate_health
UNION ALL
SELECT * FROM platform_health
UNION ALL
SELECT * FROM quarantine_health;
