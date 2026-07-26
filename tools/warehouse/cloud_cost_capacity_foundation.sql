-- CEFA measurement-platform capacity and quoted-budget registry.
-- The cost fields are planning estimates, not Cloud Billing invoice truth.

CREATE TABLE IF NOT EXISTS
  `marketing-api-488017.cefa_governance.cloud_platform_budget_registry`
(
  budget_key STRING NOT NULL,
  display_name STRING NOT NULL,
  annual_budget_amount NUMERIC NOT NULL,
  currency_code STRING NOT NULL,
  commercial_scope STRING NOT NULL,
  approval_status STRING NOT NULL,
  approval_date DATE NOT NULL,
  source_reference STRING NOT NULL,
  updated_at TIMESTAMP NOT NULL
)
OPTIONS (
  description = "Approved CEFA measurement-platform budget lines. Currency remains UNCONFIRMED until Finance confirms the quote currency."
);

MERGE
  `marketing-api-488017.cefa_governance.cloud_platform_budget_registry` AS target
USING (
  SELECT *
  FROM UNNEST([
    STRUCT(
      "gcp_measurement_platform" AS budget_key,
      "BigQuery, Dataform and Google Cloud measurement platform" AS display_name,
      NUMERIC "3377" AS annual_budget_amount,
      "UNCONFIRMED" AS currency_code,
      "BigQuery, Dataform, Cloud Run, Scheduler, Pub/Sub, Cloud Tasks, Secret Manager and related approved measurement services" AS commercial_scope,
      "approved" AS approval_status,
      DATE "2026-07-25" AS approval_date,
      "CEFA annual measurement budget image supplied 2026-07-25" AS source_reference,
      CURRENT_TIMESTAMP() AS updated_at
    ),
    STRUCT(
      "stape_sgtm" AS budget_key,
      "Server-side Google Tag Manager on Stape" AS display_name,
      NUMERIC "1370" AS annual_budget_amount,
      "UNCONFIRMED" AS currency_code,
      "Quoted annual server-side GTM line; reconcile included implementation/support against the Stape Business license" AS commercial_scope,
      "approved_reconciliation_pending" AS approval_status,
      DATE "2026-07-25" AS approval_date,
      "CEFA annual measurement budget image supplied 2026-07-25" AS source_reference,
      CURRENT_TIMESTAMP() AS updated_at
    )
  ])
) AS source
ON target.budget_key = source.budget_key
WHEN MATCHED THEN UPDATE SET
  display_name = source.display_name,
  annual_budget_amount = source.annual_budget_amount,
  currency_code = source.currency_code,
  commercial_scope = source.commercial_scope,
  approval_status = source.approval_status,
  approval_date = source.approval_date,
  source_reference = source.source_reference,
  updated_at = source.updated_at
WHEN NOT MATCHED THEN INSERT (
  budget_key,
  display_name,
  annual_budget_amount,
  currency_code,
  commercial_scope,
  approval_status,
  approval_date,
  source_reference,
  updated_at
) VALUES (
  source.budget_key,
  source.display_name,
  source.annual_budget_amount,
  source.currency_code,
  source.commercial_scope,
  source.approval_status,
  source.approval_date,
  source.source_reference,
  source.updated_at
);

CREATE OR REPLACE VIEW
  `marketing-api-488017.cefa_ops.vw_bigquery_usage_monthly`
OPTIONS (
  description = "Monthly BigQuery query volume and an indicative on-demand analysis estimate. The USD estimate assumes $6.25/TiB and a fully available first 1 TiB monthly free allowance; it is not invoice truth."
) AS
SELECT
  DATE_TRUNC(DATE(creation_time, "America/Vancouver"), MONTH) AS usage_month,
  COUNT(*) AS query_jobs,
  COUNTIF(error_result IS NOT NULL) AS failed_query_jobs,
  ROUND(SUM(COALESCE(total_bytes_processed, 0)) / POW(1024, 4), 4)
    AS tib_processed,
  ROUND(SUM(COALESCE(total_bytes_billed, 0)) / POW(1024, 4), 4)
    AS tib_billed,
  ROUND(SUM(COALESCE(total_slot_ms, 0)) / 3600000, 2) AS slot_hours,
  ROUND(
    GREATEST(
      SUM(COALESCE(total_bytes_billed, 0)) / POW(1024, 4) - 1,
      0
    ) * 6.25,
    2
  ) AS indicative_analysis_usd_after_free_allowance
FROM `region-us`.INFORMATION_SCHEMA.JOBS_BY_PROJECT
WHERE creation_time >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 180 DAY)
  AND job_type = "QUERY"
  AND state = "DONE"
GROUP BY usage_month;

CREATE OR REPLACE VIEW
  `marketing-api-488017.cefa_ops.vw_bigquery_storage_current`
OPTIONS (
  description = "Current durable BigQuery logical storage by dataset. Temporary script datasets are excluded."
) AS
SELECT
  CURRENT_DATE("America/Vancouver") AS snapshot_date,
  table_schema,
  COUNT(*) AS table_count,
  ROUND(SUM(total_logical_bytes) / POW(1024, 3), 3) AS logical_gib,
  ROUND(SUM(active_logical_bytes) / POW(1024, 3), 3) AS active_logical_gib,
  ROUND(SUM(long_term_logical_bytes) / POW(1024, 3), 3)
    AS long_term_logical_gib
FROM `region-us`.INFORMATION_SCHEMA.TABLE_STORAGE_BY_PROJECT
WHERE NOT STARTS_WITH(table_schema, "_script")
GROUP BY snapshot_date, table_schema;

CREATE OR REPLACE VIEW
  `marketing-api-488017.cefa_ops.vw_stape_parent_capacity_proxy_monthly`
OPTIONS (
  description = "Parent GA4 exported event rows compared with the Stape Business 5M monthly request allowance. This is a planning proxy only; Stape request logs become authoritative after the server container is connected."
) AS
WITH daily_events AS (
  SELECT
    PARSE_DATE("%Y%m%d", REGEXP_EXTRACT(table_name, r"^events_([0-9]{8})$"))
      AS event_date,
    total_rows
  FROM `region-us`.INFORMATION_SCHEMA.TABLE_STORAGE_BY_PROJECT
  WHERE table_schema = "analytics_267558140"
    AND REGEXP_CONTAINS(table_name, r"^events_[0-9]{8}$")
)
SELECT
  DATE_TRUNC(event_date, MONTH) AS usage_month,
  SUM(total_rows) AS parent_ga4_event_rows,
  5000000 AS stape_business_monthly_request_allowance,
  5000000 - SUM(total_rows) AS proxy_remaining_requests,
  ROUND(SAFE_DIVIDE(SUM(total_rows), 5000000) * 100, 2)
    AS proxy_allowance_utilization_pct
FROM daily_events
GROUP BY usage_month;

CREATE OR REPLACE VIEW
  `marketing-api-488017.cefa_ops.vw_measurement_platform_capacity_board`
OPTIONS (
  description = "Current CEFA measurement-platform capacity board combining BigQuery usage, durable storage and the parent GA4 planning proxy for Stape."
) AS
WITH current_bq AS (
  SELECT *
  FROM `marketing-api-488017.cefa_ops.vw_bigquery_usage_monthly`
  WHERE usage_month = DATE_TRUNC(
    CURRENT_DATE("America/Vancouver"),
    MONTH
  )
),
current_storage AS (
  SELECT
    SUM(table_count) AS durable_table_count,
    ROUND(SUM(logical_gib), 3) AS durable_logical_gib
  FROM `marketing-api-488017.cefa_ops.vw_bigquery_storage_current`
),
current_stape_proxy AS (
  SELECT *
  FROM `marketing-api-488017.cefa_ops.vw_stape_parent_capacity_proxy_monthly`
  WHERE usage_month = DATE_TRUNC(
    CURRENT_DATE("America/Vancouver"),
    MONTH
  )
)
SELECT
  CURRENT_DATE("America/Vancouver") AS report_date,
  COALESCE(current_bq.query_jobs, 0) AS bigquery_query_jobs_mtd,
  COALESCE(current_bq.failed_query_jobs, 0) AS bigquery_failed_query_jobs_mtd,
  COALESCE(current_bq.tib_billed, 0) AS bigquery_tib_billed_mtd,
  COALESCE(current_bq.indicative_analysis_usd_after_free_allowance, 0)
    AS indicative_bigquery_analysis_usd_mtd,
  COALESCE(current_storage.durable_table_count, 0) AS durable_table_count,
  COALESCE(current_storage.durable_logical_gib, 0) AS durable_logical_gib,
  COALESCE(current_stape_proxy.parent_ga4_event_rows, 0)
    AS parent_ga4_event_rows_mtd,
  COALESCE(
    current_stape_proxy.stape_business_monthly_request_allowance,
    5000000
  ) AS stape_business_monthly_request_allowance,
  COALESCE(current_stape_proxy.proxy_allowance_utilization_pct, 0)
    AS stape_parent_proxy_allowance_utilization_pct,
  "planning_proxy_not_invoice_truth" AS capacity_status
FROM current_storage
LEFT JOIN current_bq ON TRUE
LEFT JOIN current_stape_proxy ON TRUE;

CREATE OR REPLACE VIEW
  `marketing-api-488017.cefa_ops.vw_parent_identity_binder_health`
OPTIONS (
  description = "Aggregate-only health surface for the restricted Parent Form 4 to GreenRope identity binder. It exposes no row identifiers or parent/child data."
) AS
SELECT
  CURRENT_TIMESTAMP() AS observed_at,
  COUNT(*) AS identity_rows,
  COUNTIF(bridge_status = "captured") AS captured_rows,
  COUNTIF(bridge_status = "retryable_failure") AS retryable_failure_rows,
  COUNTIF(bridge_status = "quarantined") AS quarantined_rows,
  COUNTIF(opportunity_id_hmac IS NOT NULL) AS opportunity_matched_rows,
  COUNTIF(greenrope_readback_confirmed) AS readback_confirmed_rows,
  MAX(attempt_count) AS max_attempt_count,
  COUNTIF(attempt_count >= 24) AS rows_with_excessive_attempts,
  MAX(last_attempt_at) AS latest_attempt_at,
  CASE
    WHEN COUNTIF(greenrope_readback_confirmed) > 0 THEN "identity_readback_present"
    WHEN COUNTIF(attempt_count >= 24) > 0 THEN "blocked_retry_storm_contained"
    WHEN COUNTIF(bridge_status = "retryable_failure") > 0 THEN "blocked_candidate_wait"
    ELSE "capture_only"
  END AS binder_health_state,
  CASE
    WHEN COUNTIF(greenrope_readback_confirmed) = 0
      AND COUNTIF(bridge_status = "retryable_failure") > 0
    THEN "PAUSED"
    ELSE "REVIEW"
  END AS recommended_schedule_state
FROM
  `marketing-api-488017.cefa_parent_activation_restricted.parent_form4_identity_inbox`;

CREATE OR REPLACE VIEW
  `marketing-api-488017.dataform_assertions.assert_bq_usage_guardrails`
OPTIONS (
  description = "Capacity anomaly assertion aligned with the approved paid Google Cloud plan. It does not enforce the superseded free-tier stop status."
) AS
SELECT *
FROM `marketing-api-488017.cefa_ops.vw_measurement_platform_capacity_board`
WHERE bigquery_tib_billed_mtd >= 40
   OR durable_logical_gib >= 500;
