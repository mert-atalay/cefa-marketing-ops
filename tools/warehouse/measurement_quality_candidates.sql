-- Additive measurement-quality candidates.
--
-- These views do not replace or alter any dashboard-facing object. They provide
-- parallel contracts that can be validated before an explicit promotion.

CREATE OR REPLACE VIEW
  `marketing-api-488017.mart_marketing_franchise.franchise_ga4_property_daily_candidate`
AS
SELECT
  date,
  month_date,
  site_context,
  property_id,
  site_label,
  sessions,
  total_users,
  engaged_sessions,
  engagement_rate,
  generate_lead_events,
  source_loaded_at,
  data_through_date,
  last_loaded_at,
  source_systems,
  qa_status,
  reconciliation_status,
  intelligence_safe,
  dashboard_safe,
  warehouse_run_id
FROM
  `marketing-api-488017.mart_marketing_franchise.fact_franchise_ga4_website_monthly_snapshot_latest`
WHERE
  metric_grain = 'property'
  AND site_context IN ('franchise_ca', 'franchise_us')
  AND (
    (site_context = 'franchise_ca' AND property_id = '259747921')
    OR (site_context = 'franchise_us' AND property_id = '519783092')
  );

CREATE OR REPLACE VIEW
  `marketing-api-488017.mart_marketing_franchise.franchise_ga4_landing_page_daily_sanitized_candidate`
AS
WITH sanitized AS (
  SELECT
    date,
    month_date,
    site_context,
    property_id,
    site_label,
    NULLIF(REGEXP_REPLACE(COALESCE(landing_page, ''), r'[?#].*$', ''), '') AS landing_page_path,
    sessions,
    total_users,
    engaged_sessions,
    generate_lead_events,
    source_loaded_at,
    data_through_date,
    last_loaded_at,
    source_systems,
    qa_status,
    reconciliation_status,
    intelligence_safe,
    warehouse_run_id
  FROM
    `marketing-api-488017.mart_marketing_franchise.fact_franchise_ga4_website_monthly_snapshot_latest`
  WHERE
    metric_grain = 'landing_page'
    AND site_context IN ('franchise_ca', 'franchise_us')
)
SELECT
  date,
  month_date,
  site_context,
  property_id,
  site_label,
  landing_page_path,
  SUM(sessions) AS sessions,
  SUM(total_users) AS total_users,
  SUM(engaged_sessions) AS engaged_sessions,
  SAFE_DIVIDE(SUM(engaged_sessions), SUM(sessions)) AS engagement_rate,
  SUM(generate_lead_events) AS generate_lead_events,
  MAX(source_loaded_at) AS source_loaded_at,
  MAX(data_through_date) AS data_through_date,
  MAX(last_loaded_at) AS last_loaded_at,
  STRING_AGG(DISTINCT source_systems, ',' ORDER BY source_systems) AS source_systems,
  IF(COUNTIF(qa_status != 'pass') = 0, 'pass', 'review') AS qa_status,
  IF(COUNTIF(reconciliation_status NOT IN ('pass', 'reconciled')) = 0, 'pass', 'review')
    AS reconciliation_status,
  LOGICAL_AND(COALESCE(intelligence_safe, FALSE)) AS intelligence_safe,
  TRUE AS candidate_dashboard_safe,
  'parallel_only' AS promotion_status,
  STRING_AGG(DISTINCT warehouse_run_id, ',' ORDER BY warehouse_run_id) AS warehouse_run_ids
FROM sanitized
GROUP BY
  date,
  month_date,
  site_context,
  property_id,
  site_label,
  landing_page_path;

CREATE OR REPLACE VIEW
  `marketing-api-488017.mart_marketing_franchise.franchise_ga4_form_reconciliation_monthly_candidate`
AS
WITH ga4 AS (
  SELECT
    month_date,
    site_context,
    property_id,
    SUM(generate_lead_events) AS ga4_generate_leads,
    MAX(data_through_date) AS ga4_data_through_date
  FROM
    `marketing-api-488017.mart_marketing_franchise.franchise_ga4_property_daily_candidate`
  GROUP BY month_date, site_context, property_id
),
forms AS (
  SELECT
    month_date,
    site_context,
    SUM(website_form_submissions) AS website_form_submissions,
    MAX(data_through_date) AS forms_data_through_date
  FROM
    `marketing-api-488017.mart_marketing_franchise.fact_franchise_form_daily_latest`
  WHERE site_context IN ('franchise_ca', 'franchise_us')
  GROUP BY month_date, site_context
)
SELECT
  COALESCE(ga4.month_date, forms.month_date) AS month_date,
  COALESCE(ga4.site_context, forms.site_context) AS site_context,
  ga4.property_id,
  ga4.ga4_generate_leads,
  forms.website_form_submissions,
  ga4.ga4_generate_leads - forms.website_form_submissions AS lead_delta,
  SAFE_DIVIDE(
    ABS(ga4.ga4_generate_leads - forms.website_form_submissions),
    NULLIF(forms.website_form_submissions, 0)
  ) AS absolute_delta_rate,
  ga4.ga4_data_through_date,
  forms.forms_data_through_date,
  CASE
    WHEN ga4.ga4_generate_leads IS NULL OR forms.website_form_submissions IS NULL THEN 'pending'
    WHEN SAFE_DIVIDE(
      ABS(ga4.ga4_generate_leads - forms.website_form_submissions),
      NULLIF(forms.website_form_submissions, 0)
    ) > 0.10 THEN 'fail'
    WHEN SAFE_DIVIDE(
      ABS(ga4.ga4_generate_leads - forms.website_form_submissions),
      NULLIF(forms.website_form_submissions, 0)
    ) > 0.05 THEN 'warn'
    ELSE 'pass'
  END AS reconciliation_status,
  'parallel_only' AS promotion_status
FROM ga4
FULL OUTER JOIN forms
  ON ga4.month_date = forms.month_date
  AND ga4.site_context = forms.site_context;

CREATE OR REPLACE VIEW
  `marketing-api-488017.mart_marketing_franchise.franchise_native_export_arrival_candidate`
AS
WITH expected AS (
  SELECT 'franchise_ca' AS site_context, '259747921' AS property_id, 'analytics_259747921' AS dataset_name
  UNION ALL
  SELECT 'franchise_us', '519783092', 'analytics_519783092'
),
inventory AS (
  SELECT
    table_schema AS dataset_name,
    COUNTIF(REGEXP_CONTAINS(table_name, r'^events_[0-9]{8}$')) AS daily_table_count,
    MAX(
      SAFE.PARSE_DATE(
        '%Y%m%d',
        REGEXP_EXTRACT(table_name, r'^events_([0-9]{8})$')
      )
    ) AS latest_event_date
  FROM `marketing-api-488017.region-us`.INFORMATION_SCHEMA.TABLES
  WHERE table_schema IN ('analytics_259747921', 'analytics_519783092')
  GROUP BY table_schema
)
SELECT
  expected.site_context,
  expected.property_id,
  expected.dataset_name,
  COALESCE(inventory.daily_table_count, 0) AS daily_table_count,
  inventory.latest_event_date,
  DATE_DIFF(CURRENT_DATE('America/Vancouver'), inventory.latest_event_date, DAY) AS freshness_lag_days,
  CASE
    WHEN COALESCE(inventory.daily_table_count, 0) = 0
      AND CURRENT_DATE('America/Vancouver') <= DATE '2026-08-02' THEN 'pending'
    WHEN COALESCE(inventory.daily_table_count, 0) = 0 THEN 'fail'
    WHEN DATE_DIFF(CURRENT_DATE('America/Vancouver'), inventory.latest_event_date, DAY) > 3 THEN 'fail'
    WHEN DATE_DIFF(CURRENT_DATE('America/Vancouver'), inventory.latest_event_date, DAY) > 2 THEN 'warn'
    ELSE 'pass'
  END AS arrival_status,
  'No native GA4 history is expected before link activation on 2026-07-31.' AS status_note
FROM expected
LEFT JOIN inventory USING (dataset_name);

CREATE OR REPLACE VIEW
  `marketing-api-488017.mart_cefa_growth_intelligence.input_student_growth_paid_monthly_direct_candidate`
AS
WITH config AS (
  SELECT DATE_TRUNC(CURRENT_DATE('America/Vancouver'), MONTH) AS replacement_start_month
),
historical AS (
  SELECT existing.*
  FROM `marketing-api-488017.mart_cefa_growth_intelligence.input_student_growth_paid_monthly` AS existing
  CROSS JOIN config
  WHERE existing.month_date < config.replacement_start_month
),
paid_base AS (
  SELECT
    DATE_TRUNC(report_date, MONTH) AS month_date,
    platform,
    account_id,
    ANY_VALUE(account_name) AS account_name,
    ANY_VALUE(currency) AS currency,
    SUM(spend) AS spend,
    CAST(ROUND(SUM(impressions)) AS INT64) AS impressions,
    SUM(clicks) AS clicks,
    SUM(IF(platform = 'meta_ads', COALESCE(parent_inquiry_submits, 0), 0))
      AS meta_parent_inquiry_submits,
    MIN(report_date) AS query_start_date,
    MAX(report_date) AS query_end_date,
    MAX(generated_at) AS extracted_at
  FROM `marketing-api-488017.raw_supermetrics_hub.vw_paid_media_campaign_daily_ytd`
  CROSS JOIN config
  WHERE report_date >= config.replacement_start_month
    AND (
      (platform = 'google_ads' AND account_id = '4159217891')
      OR (platform = 'meta_ads' AND account_id = '1595846967472729')
    )
  GROUP BY month_date, platform, account_id
),
google_inquiries AS (
  SELECT
    DATE_TRUNC(report_date, MONTH) AS month_date,
    SUM(conversions) AS platform_inquiry_submits
  FROM `marketing-api-488017.raw_google_ads.google_ads_conversion_action_campaign_daily_direct`
  CROSS JOIN config
  WHERE report_date >= config.replacement_start_month
    AND account_id = '4159217891'
    AND REGEXP_CONTAINS(LOWER(conversion_type_name), r'inquiry submit')
    AND NOT REGEXP_CONTAINS(
      LOWER(conversion_type_name),
      r'subsidy|franchise|job|application|contact|click'
    )
  GROUP BY month_date
),
direct AS (
  SELECT
    paid_base.month_date,
    paid_base.platform,
    paid_base.account_id,
    paid_base.account_name,
    paid_base.currency,
    CAST(paid_base.spend AS NUMERIC) AS spend,
    paid_base.impressions,
    paid_base.clicks,
    CAST(
      IF(
        paid_base.platform = 'google_ads',
        COALESCE(google_inquiries.platform_inquiry_submits, 0),
        paid_base.meta_parent_inquiry_submits
      ) AS NUMERIC
    ) AS platform_inquiry_submits,
    IF(
      paid_base.platform = 'google_ads',
      'Google Ads conversion actions containing Inquiry Submit, excluding subsidy, franchise, job, application, contact, and click actions.',
      'Meta action labels normalized to Parent Inquiry Submit.'
    ) AS conversion_definition,
    paid_base.query_end_date AS source_data_through_date,
    paid_base.query_start_date,
    paid_base.query_end_date,
    'live' AS source_status,
    'pass' AS qa_status,
    'parallel_candidate' AS reconciliation_status,
    'Platform-reported inquiry signals are not deduplicated people or confirmed student starts; use BI/lifecycle facts for business outcomes.'
      AS known_limitations,
    FALSE AS dashboard_safe,
    TRUE AS intelligence_safe,
    'canonical_paid_media_view,direct_google_conversion_actions' AS source_systems,
    paid_base.extracted_at,
    'view:canonical_paid_media_current_month' AS source_query_hash,
    'student_growth_paid_history_direct_candidate_v1' AS source_query_version
  FROM paid_base
  LEFT JOIN google_inquiries USING (month_date)
)
SELECT * FROM historical
UNION ALL BY NAME
SELECT * FROM direct;

CREATE OR REPLACE VIEW
  `marketing-api-488017.mart_cefa_growth_intelligence.student_growth_paid_history_source_health_candidate`
AS
WITH sources AS (
  SELECT
    'google_paid_media' AS source_name,
    MAX(report_date) AS source_data_through_date
  FROM `marketing-api-488017.raw_supermetrics_hub.vw_paid_media_campaign_daily_ytd`
  WHERE platform = 'google_ads'
    AND account_id = '4159217891'
  UNION ALL
  SELECT
    'google_inquiry_actions',
    MAX(report_date)
  FROM `marketing-api-488017.raw_google_ads.google_ads_conversion_action_campaign_daily_direct`
  WHERE account_id = '4159217891'
    AND REGEXP_CONTAINS(LOWER(conversion_type_name), r'inquiry submit')
    AND NOT REGEXP_CONTAINS(
      LOWER(conversion_type_name),
      r'subsidy|franchise|job|application|contact|click'
    )
  UNION ALL
  SELECT
    'meta_paid_media_and_inquiries',
    MAX(IF(parent_inquiry_submits IS NOT NULL, report_date, NULL))
  FROM `marketing-api-488017.raw_supermetrics_hub.vw_paid_media_campaign_daily_ytd`
  WHERE platform = 'meta_ads'
    AND account_id = '1595846967472729'
)
SELECT
  source_name,
  source_data_through_date,
  DATE_DIFF(CURRENT_DATE('America/Vancouver'), source_data_through_date, DAY)
    AS freshness_lag_days,
  CASE
    WHEN source_data_through_date IS NULL THEN 'fail'
    WHEN DATE_DIFF(CURRENT_DATE('America/Vancouver'), source_data_through_date, DAY) > 3 THEN 'fail'
    WHEN DATE_DIFF(CURRENT_DATE('America/Vancouver'), source_data_through_date, DAY) > 2 THEN 'warn'
    ELSE 'pass'
  END AS freshness_status,
  'parallel_only' AS promotion_status
FROM sources;

CREATE OR REPLACE VIEW
  `marketing-api-488017.mart_cefa_growth_intelligence.student_growth_paid_history_health_candidate`
AS
WITH current_input AS (
  SELECT
    'current_supermetrics_input' AS source_name,
    MAX(source_data_through_date) AS source_data_through_date,
    MAX(extracted_at) AS last_extract,
    COUNT(*) AS row_count
  FROM `marketing-api-488017.mart_cefa_growth_intelligence.input_student_growth_paid_monthly`
),
direct_candidate_output AS (
  SELECT
    MAX(extracted_at) AS last_extract,
    COUNT(*) AS row_count
  FROM `marketing-api-488017.mart_cefa_growth_intelligence.input_student_growth_paid_monthly_direct_candidate`
),
direct_candidate AS (
  SELECT
    'direct_candidate_input' AS source_name,
    MIN(source_data_through_date) AS source_data_through_date,
    ANY_VALUE(direct_candidate_output.last_extract) AS last_extract,
    ANY_VALUE(direct_candidate_output.row_count) AS row_count
  FROM `marketing-api-488017.mart_cefa_growth_intelligence.student_growth_paid_history_source_health_candidate`
  CROSS JOIN direct_candidate_output
)
SELECT
  source_name,
  source_data_through_date,
  last_extract,
  row_count,
  DATE_DIFF(CURRENT_DATE('America/Vancouver'), source_data_through_date, DAY) AS freshness_lag_days,
  CASE
    WHEN source_data_through_date IS NULL THEN 'fail'
    WHEN DATE_DIFF(CURRENT_DATE('America/Vancouver'), source_data_through_date, DAY) > 3 THEN 'fail'
    WHEN DATE_DIFF(CURRENT_DATE('America/Vancouver'), source_data_through_date, DAY) > 2 THEN 'warn'
    ELSE 'pass'
  END AS freshness_status,
  'parallel_only' AS promotion_status
FROM current_input
UNION ALL
SELECT
  source_name,
  source_data_through_date,
  last_extract,
  row_count,
  DATE_DIFF(CURRENT_DATE('America/Vancouver'), source_data_through_date, DAY),
  CASE
    WHEN source_data_through_date IS NULL THEN 'fail'
    WHEN DATE_DIFF(CURRENT_DATE('America/Vancouver'), source_data_through_date, DAY) > 3 THEN 'fail'
    WHEN DATE_DIFF(CURRENT_DATE('America/Vancouver'), source_data_through_date, DAY) > 2 THEN 'warn'
    ELSE 'pass'
  END,
  'parallel_only'
FROM direct_candidate;
