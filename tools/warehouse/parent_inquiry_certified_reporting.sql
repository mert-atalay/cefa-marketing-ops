-- CEFA Parent inquiry reporting contract.
--
-- Gravity Forms Form 4 is the inquiry and selected-school authority. GA4 is
-- joined only by the stable CEFA event ID and remains supporting session
-- attribution. No raw click IDs or direct identifiers are exposed here.

CREATE OR REPLACE VIEW
  `marketing-api-488017.mart_marketing.vw_parent_inquiry_certified_event`
OPTIONS (
  description = 'One non-test Gravity Forms Form 4 entry per row, enriched by exact CEFA event-ID GA4 session attribution. Gravity Forms remains the inquiry and selected-school authority.'
) AS
WITH gravity_base AS (
  SELECT
    submitted_date,
    submitted_at,
    received_at,
    event_id,
    form_id,
    entry_id,
    program_id,
    selected_school_uuid,
    selected_school_slug,
    selected_school_name,
    selected_school_region,
    source_location_name,
    source,
    medium,
    campaign,
    source_bucket,
    source_detail,
    has_paid_evidence,
    paid_channel,
    paid_evidence_type,
    has_utm_source,
    has_utm_medium,
    has_utm_campaign,
    has_gclid,
    has_gbraid,
    has_wbraid,
    has_msclkid,
    has_fbclid,
    has_fbc,
    has_fbp,
    campaign_target_school_slug,
    campaign_target_school_name,
    campaign_target_match_type,
    school_match_type,
    is_cross_school_inquiry,
    generated_at
  FROM `marketing-api-488017.mart_marketing.vw_website_form_submission_events`
  WHERE is_test_submission = FALSE
    AND submitted_date >= DATE '2026-06-25'
),
gravity_identity_profile AS (
  SELECT
    event_id,
    COUNT(DISTINCT entry_id) AS gravity_event_id_entry_count
  FROM gravity_base
  WHERE event_id IS NOT NULL
    AND event_id != ''
  GROUP BY event_id
),
ga4_raw AS (
  SELECT
    PARSE_DATE('%Y%m%d', event_date) AS ga4_export_date,
    TIMESTAMP_MICROS(event_timestamp) AS ga4_event_timestamp,
    COALESCE(
      (SELECT value.string_value FROM UNNEST(event_params) WHERE key = 'event_id' LIMIT 1),
      (SELECT value.string_value FROM UNNEST(event_params) WHERE key = 'cefa_event_id' LIMIT 1),
      (SELECT value.string_value FROM UNNEST(event_params) WHERE key = 'transaction_id' LIMIT 1)
    ) AS event_id,
    (SELECT value.string_value FROM UNNEST(event_params) WHERE key = 'school_selected_id' LIMIT 1)
      AS ga4_school_selected_id,
    (SELECT value.string_value FROM UNNEST(event_params) WHERE key = 'school_selected_slug' LIMIT 1)
      AS ga4_school_selected_slug,
    (SELECT value.string_value FROM UNNEST(event_params) WHERE key = 'school_selected_name' LIMIT 1)
      AS ga4_school_selected_name,
    COALESCE(
      session_traffic_source_last_click.cross_channel_campaign.source,
      IF(session_traffic_source_last_click.google_ads_campaign.campaign_id IS NOT NULL, 'google', NULL),
      collected_traffic_source.manual_source,
      '(direct)'
    ) AS ga4_session_source,
    COALESCE(
      session_traffic_source_last_click.cross_channel_campaign.medium,
      IF(session_traffic_source_last_click.google_ads_campaign.campaign_id IS NOT NULL, 'cpc', NULL),
      collected_traffic_source.manual_medium,
      '(none)'
    ) AS ga4_session_medium,
    COALESCE(
      session_traffic_source_last_click.google_ads_campaign.campaign_name,
      session_traffic_source_last_click.cross_channel_campaign.campaign_name,
      collected_traffic_source.manual_campaign_name,
      '(not set)'
    ) AS ga4_session_campaign,
    COALESCE(
      session_traffic_source_last_click.cross_channel_campaign.default_channel_group,
      CASE
        WHEN session_traffic_source_last_click.google_ads_campaign.campaign_id IS NOT NULL THEN 'Paid Search'
        WHEN LOWER(COALESCE(collected_traffic_source.manual_medium, ''))
          IN ('cpc', 'ppc', 'paid_search') THEN 'Paid Search'
        WHEN LOWER(COALESCE(collected_traffic_source.manual_medium, ''))
          IN ('paid_social', 'paidsocial') THEN 'Paid Social'
        WHEN LOWER(COALESCE(collected_traffic_source.manual_medium, '')) = 'organic'
          THEN 'Organic Search'
        WHEN collected_traffic_source.manual_source IS NULL THEN 'Direct'
        ELSE 'Unassigned'
      END
    ) AS ga4_default_channel_group,
    session_traffic_source_last_click.google_ads_campaign.campaign_id AS ga4_google_ads_campaign_id,
    session_traffic_source_last_click.google_ads_campaign.campaign_name AS ga4_google_ads_campaign_name
  FROM `marketing-api-488017.analytics_267558140.events_*`
  WHERE _TABLE_SUFFIX BETWEEN '20260625'
    AND FORMAT_DATE('%Y%m%d', DATE_SUB(CURRENT_DATE('America/Vancouver'), INTERVAL 1 DAY))
    AND event_name = 'generate_lead'
),
ga4_by_event_id AS (
  SELECT
    event_id,
    COUNT(*) AS ga4_event_count,
    ARRAY_AGG(
      STRUCT(
        ga4_export_date,
        ga4_event_timestamp,
        ga4_school_selected_id,
        ga4_school_selected_slug,
        ga4_school_selected_name,
        ga4_session_source,
        ga4_session_medium,
        ga4_session_campaign,
        ga4_default_channel_group,
        ga4_google_ads_campaign_id,
        ga4_google_ads_campaign_name
      )
      ORDER BY ga4_event_timestamp
      LIMIT 1
    )[OFFSET(0)] AS first_ga4_event
  FROM ga4_raw
  WHERE event_id IS NOT NULL
    AND event_id != ''
  GROUP BY event_id
),
ga4_freshness AS (
  SELECT MAX(ga4_export_date) AS ga4_data_through_date
  FROM ga4_raw
),
joined AS (
  SELECT
    g.*,
    IFNULL(p.gravity_event_id_entry_count, 0) AS gravity_event_id_entry_count,
    IFNULL(a.ga4_event_count, 0) AS ga4_event_count,
    a.first_ga4_event,
    f.ga4_data_through_date
  FROM gravity_base AS g
  LEFT JOIN gravity_identity_profile AS p USING (event_id)
  LEFT JOIN ga4_by_event_id AS a USING (event_id)
  CROSS JOIN ga4_freshness AS f
)
SELECT
  submitted_date,
  submitted_at,
  received_at,
  event_id,
  form_id,
  entry_id,
  program_id,
  selected_school_uuid,
  selected_school_slug,
  selected_school_name,
  selected_school_region,
  source_location_name,
  source AS first_party_source,
  medium AS first_party_medium,
  campaign AS first_party_campaign,
  source_bucket AS certified_source_bucket,
  source_detail AS certified_source_detail,
  has_paid_evidence AS certified_paid_evidence,
  paid_channel AS certified_paid_channel,
  paid_evidence_type AS certified_paid_evidence_type,
  has_utm_source,
  has_utm_medium,
  has_utm_campaign,
  has_gclid,
  has_gbraid,
  has_wbraid,
  has_msclkid,
  has_fbclid,
  has_fbc,
  has_fbp,
  campaign_target_school_slug,
  campaign_target_school_name,
  campaign_target_match_type,
  school_match_type,
  is_cross_school_inquiry,
  ga4_event_count > 0 AS ga4_event_present,
  gravity_event_id_entry_count = 1 AND ga4_event_count = 1 AS ga4_attribution_eligible,
  ga4_event_count,
  first_ga4_event.ga4_export_date,
  first_ga4_event.ga4_event_timestamp,
  first_ga4_event.ga4_school_selected_id,
  first_ga4_event.ga4_school_selected_slug,
  first_ga4_event.ga4_school_selected_name,
  first_ga4_event.ga4_session_source,
  first_ga4_event.ga4_session_medium,
  first_ga4_event.ga4_session_campaign,
  first_ga4_event.ga4_default_channel_group,
  first_ga4_event.ga4_google_ads_campaign_id,
  first_ga4_event.ga4_google_ads_campaign_name,
  gravity_event_id_entry_count,
  CASE
    WHEN event_id IS NULL OR event_id = '' THEN 'missing_gravity_event_id'
    WHEN gravity_event_id_entry_count > 1 THEN 'ambiguous_gravity_event_id'
    WHEN ga4_event_count = 0 THEN 'ga4_event_not_observed'
    WHEN ga4_event_count > 1 THEN 'duplicate_ga4_event_id'
    ELSE 'exact_event_id_match'
  END AS event_id_reconciliation_status,
  CASE
    WHEN ga4_event_count = 0 THEN 'ga4_school_not_observed'
    WHEN first_ga4_event.ga4_school_selected_id IS NULL
      AND first_ga4_event.ga4_school_selected_slug IS NULL THEN 'ga4_school_parameter_missing'
    WHEN first_ga4_event.ga4_school_selected_id = selected_school_uuid
      OR first_ga4_event.ga4_school_selected_id = CAST(selected_school_uuid AS STRING)
      OR first_ga4_event.ga4_school_selected_slug = selected_school_slug THEN 'school_match'
    ELSE 'school_mismatch_review'
  END AS school_reconciliation_status,
  CASE
    WHEN ga4_event_count = 0 THEN 'ga4_unmatched'
    WHEN has_paid_evidence
      AND first_ga4_event.ga4_default_channel_group IN ('Paid Search', 'Paid Social', 'Cross-network')
      THEN 'paid_agreement'
    WHEN has_paid_evidence THEN 'first_party_paid_ga4_non_paid'
    WHEN NOT has_paid_evidence
      AND first_ga4_event.ga4_default_channel_group IN ('Paid Search', 'Paid Social', 'Cross-network')
      THEN 'ga4_paid_without_first_party_paid_evidence'
    ELSE 'non_paid_or_other_agreement'
  END AS source_agreement_status,
  CASE
    WHEN selected_school_uuid IS NULL OR selected_school_uuid = '' THEN 'fail'
    WHEN event_id IS NULL OR event_id = '' THEN 'fail'
    WHEN gravity_event_id_entry_count > 1 OR ga4_event_count != 1 THEN 'warning'
    ELSE 'pass'
  END AS qa_status,
  'gravity_forms_form_4_saved_entry' AS inquiry_count_authority,
  'gravity_forms_selected_school' AS school_attribution_authority,
  'cefa_first_party_attribution_ledger' AS source_attribution_authority,
  'supporting_ga4_session_last_click' AS ga4_attribution_role,
  DATE '2026-06-25' AS event_identity_contract_start_date,
  ga4_data_through_date,
  GREATEST(
    IFNULL(generated_at, TIMESTAMP '1970-01-01 00:00:00+00'),
    IFNULL(first_ga4_event.ga4_event_timestamp, TIMESTAMP '1970-01-01 00:00:00+00'),
    IFNULL(submitted_at, TIMESTAMP '1970-01-01 00:00:00+00')
  ) AS source_max_timestamp,
  CURRENT_TIMESTAMP() AS last_loaded_at,
  'ready_with_visible_ga4_exceptions' AS source_status,
  'parent_inquiry_certified_event_v1' AS source_version,
  'Gravity Forms count and selected school are authoritative. GA4 is supporting session last-click telemetry and does not reproduce Meta or Google Ads attribution windows.' AS known_limitations,
  TRUE AS dashboard_safe
FROM joined;

CREATE OR REPLACE VIEW
  `marketing-api-488017.mart_marketing.vw_parent_inquiry_school_source_certified_daily`
OPTIONS (
  description = 'Looker-friendly daily Parent inquiry counts by Gravity-selected school and certified first-party source, with supporting GA4 session attribution and visible reconciliation flags.'
) AS
SELECT
  submitted_date AS date,
  selected_school_uuid AS school_uuid,
  selected_school_slug AS school_slug,
  selected_school_name AS school_name,
  selected_school_region AS school_region,
  certified_source_bucket,
  certified_source_detail,
  certified_paid_channel,
  certified_paid_evidence_type,
  first_party_source,
  first_party_medium,
  first_party_campaign,
  COALESCE(ga4_session_source, '(GA4 unmatched)') AS ga4_session_source,
  COALESCE(ga4_session_medium, '(GA4 unmatched)') AS ga4_session_medium,
  COALESCE(ga4_session_campaign, '(GA4 unmatched)') AS ga4_session_campaign,
  COALESCE(ga4_default_channel_group, 'GA4 unmatched') AS ga4_default_channel_group,
  source_agreement_status,
  event_id_reconciliation_status,
  school_reconciliation_status,
  COUNT(*) AS gravity_form_submissions,
  COUNT(DISTINCT entry_id) AS distinct_form_entries,
  COUNT(DISTINCT event_id) AS distinct_event_ids,
  COUNTIF(certified_paid_evidence) AS paid_evidence_submissions,
  COUNTIF(certified_paid_channel = 'google') AS google_paid_evidence_submissions,
  COUNTIF(certified_paid_channel = 'meta') AS meta_paid_evidence_submissions,
  COUNTIF(ga4_event_present) AS ga4_delivery_present_submissions,
  COUNTIF(ga4_attribution_eligible) AS ga4_exact_matched_submissions,
  COUNTIF(NOT ga4_event_present) AS ga4_unmatched_submissions,
  COUNTIF(gravity_event_id_entry_count > 1) AS ambiguous_event_id_submissions,
  COUNTIF(is_cross_school_inquiry) AS cross_school_submissions,
  MAX(ga4_data_through_date) AS ga4_data_through_date,
  MAX(source_max_timestamp) AS source_max_timestamp,
  MAX(last_loaded_at) AS last_loaded_at,
  CASE WHEN COUNTIF(qa_status = 'fail') = 0 THEN 'pass_with_visible_warnings' ELSE 'review' END AS qa_status,
  'ready' AS source_status,
  'parent_inquiry_school_source_certified_daily_v1' AS serving_contract_version,
  'Gravity Forms inquiry count and selected school; CEFA first-party paid evidence; GA4 supporting session last-click. Platform-reported attribution windows are intentionally separate.' AS metric_definition,
  TRUE AS dashboard_safe
FROM `marketing-api-488017.mart_marketing.vw_parent_inquiry_certified_event`
GROUP BY
  date,
  school_uuid,
  school_slug,
  school_name,
  school_region,
  certified_source_bucket,
  certified_source_detail,
  certified_paid_channel,
  certified_paid_evidence_type,
  first_party_source,
  first_party_medium,
  first_party_campaign,
  ga4_session_source,
  ga4_session_medium,
  ga4_session_campaign,
  ga4_default_channel_group,
  source_agreement_status,
  event_id_reconciliation_status,
  school_reconciliation_status;

CREATE OR REPLACE VIEW
  `marketing-api-488017.mart_cefa_growth_dashboard.dashboard_parent_inquiry_school_source_certified_daily_candidate`
OPTIONS (
  description = 'Additive dashboard candidate. Does not replace or alter any current dashboard serving contract.'
) AS
SELECT
  *,
  'candidate_additive_not_bound_to_existing_dashboard' AS dashboard_release_status
FROM `marketing-api-488017.mart_marketing.vw_parent_inquiry_school_source_certified_daily`
WHERE dashboard_safe = TRUE;

CREATE OR REPLACE VIEW
  `marketing-api-488017.mart_marketing.vw_parent_inquiry_certified_qa_daily`
OPTIONS (
  description = 'Aggregate-only daily Parent inquiry identity, GA4 delivery, school, and source reconciliation health. Contains no parent or child identifiers.'
) AS
SELECT
  submitted_date AS date,
  COUNT(*) AS gravity_form_submissions,
  COUNTIF(event_id IS NULL OR event_id = '') AS missing_event_id_submissions,
  COUNTIF(gravity_event_id_entry_count > 1) AS ambiguous_legacy_event_id_submissions,
  COUNTIF(ga4_event_count > 1) AS duplicate_ga4_event_id_submissions,
  COUNTIF(ga4_attribution_eligible) AS exact_ga4_event_id_matches,
  COUNTIF(NOT ga4_event_present) AS ga4_unmatched_submissions,
  COUNTIF(school_reconciliation_status = 'school_match') AS ga4_school_matches,
  COUNTIF(school_reconciliation_status = 'school_mismatch_review') AS ga4_school_mismatches,
  COUNTIF(school_reconciliation_status = 'ga4_school_parameter_missing') AS ga4_school_parameter_missing,
  COUNTIF(source_agreement_status = 'paid_agreement') AS paid_source_agreements,
  COUNTIF(source_agreement_status = 'first_party_paid_ga4_non_paid') AS first_party_paid_ga4_non_paid,
  COUNTIF(source_agreement_status = 'ga4_paid_without_first_party_paid_evidence') AS ga4_paid_without_first_party_paid_evidence,
  SAFE_DIVIDE(COUNTIF(ga4_attribution_eligible), COUNT(*)) AS exact_ga4_match_rate,
  SAFE_DIVIDE(COUNTIF(ga4_event_present), COUNT(*)) AS ga4_delivery_rate,
  MAX(ga4_data_through_date) AS ga4_data_through_date,
  MAX(source_max_timestamp) AS source_max_timestamp,
  CASE
    WHEN COUNTIF(qa_status = 'fail') > 0
      OR COUNTIF(school_reconciliation_status = 'school_mismatch_review') > 0 THEN 'fail'
    WHEN submitted_date > MAX(ga4_data_through_date) THEN 'pending_ga4_export'
    WHEN COUNTIF(gravity_event_id_entry_count > 1) > 0
      OR COUNTIF(ga4_event_count > 1) > 0
      OR COUNTIF(NOT ga4_event_present) > 0 THEN 'warning'
    ELSE 'pass'
  END AS qa_status,
  'legacy browser event IDs remain supporting identity while Parent Attribution Bridge is in shadow mode; unique reserved server IDs are monitored separately in WordPress' AS identity_boundary,
  'parent_inquiry_certified_qa_daily_v1' AS serving_contract_version,
  TRUE AS dashboard_safe
FROM `marketing-api-488017.mart_marketing.vw_parent_inquiry_certified_event`
GROUP BY submitted_date;

CREATE OR REPLACE VIEW
  `marketing-api-488017.mart_marketing.vw_parent_inquiry_measurement_model_dictionary`
OPTIONS (
  description = 'Governed measurement-model dictionary preventing Gravity, first-party paid evidence, GA4, Google Ads, and Meta counts from being treated as one additive metric.'
) AS
SELECT *
FROM UNNEST([
  STRUCT(
    'gravity_saved_inquiry' AS measurement_model,
    'Gravity Forms Form 4' AS source_system,
    'Authoritative saved Parent inquiry count and selected-school truth.' AS business_meaning,
    'saved_entry' AS grain,
    'none' AS attribution_rule,
    TRUE AS inquiry_count_authority,
    FALSE AS additive_with_other_models,
    'Use for total inquiries and school-specific inquiry totals.' AS reporting_rule
  ),
  STRUCT(
    'cefa_first_party_paid_evidence',
    'CEFA attribution ledger and saved click evidence',
    'Subset of saved inquiries with verified paid evidence; not a second inquiry count.',
    'saved_entry_subset',
    'canonical first-party acquisition evidence',
    FALSE,
    FALSE,
    'Use to classify Gravity inquiries as paid; never add to total inquiries.'
  ),
  STRUCT(
    'ga4_exact_event_delivery',
    'GA4 BigQuery export',
    'Supporting proof that the website inquiry event reached GA4 with the same event ID.',
    'event_delivery',
    'exact event-ID reconciliation',
    FALSE,
    FALSE,
    'Use for delivery QA and session context, not as a replacement inquiry total.'
  ),
  STRUCT(
    'ga4_session_last_click',
    'GA4 BigQuery export',
    'GA4 session acquisition context for an exactly matched inquiry event.',
    'matched_saved_entry',
    'GA4 session last click',
    FALSE,
    FALSE,
    'Use for GA4 acquisition analysis; it does not reproduce ad-platform attribution windows.'
  ),
  STRUCT(
    'google_ads_platform_conversion',
    'Google Ads',
    'Google-reported conversions credited under the selected Google Ads attribution settings.',
    'platform_attributed_conversion',
    'Google Ads configured attribution',
    FALSE,
    FALSE,
    'Report separately for optimization and platform reconciliation.'
  ),
  STRUCT(
    'meta_platform_conversion',
    'Meta Ads',
    'Meta-reported conversions credited under the selected Meta attribution window.',
    'platform_attributed_conversion',
    'Meta configured click/view attribution window',
    FALSE,
    FALSE,
    'Report separately for optimization and platform reconciliation.'
  )
]);

CREATE OR REPLACE VIEW
  `marketing-api-488017.mart_cefa_growth_dashboard.dashboard_parent_inquiry_certified_qa_daily_candidate`
OPTIONS (
  description = 'Additive aggregate-only QA candidate for Parent inquiry reporting. Does not alter a current dashboard serving contract.'
) AS
SELECT
  *,
  'candidate_additive_not_bound_to_existing_dashboard' AS dashboard_release_status
FROM `marketing-api-488017.mart_marketing.vw_parent_inquiry_certified_qa_daily`
WHERE dashboard_safe = TRUE;
