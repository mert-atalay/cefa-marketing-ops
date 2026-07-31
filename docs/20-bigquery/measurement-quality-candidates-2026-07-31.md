# Measurement Quality Candidates - 2026-07-31

## Purpose

This change adds parallel BigQuery and Dataform quality contracts without
changing any existing dashboard, campaign, conversion, CRM, form, scheduler,
or dispatcher behavior.

Source of truth:

- `tools/warehouse/measurement_quality_candidates.sql`
- `dataform/cefa-marketing-warehouse-qa/definitions/*candidate*.sqlx`
- `dataform/cefa-marketing-warehouse-qa/definitions/assert_student_growth_paid_history_sources_fresh.sqlx`

All new BigQuery objects end in `_candidate` and remain `parallel_only` until
an explicit promotion is approved.

## Applied Additive Views

### Franchise GA4

- `mart_marketing_franchise.franchise_ga4_property_daily_candidate`
  isolates the correct Canada and USA property grain and excludes the `all`
  rollup.
- `mart_marketing_franchise.franchise_ga4_landing_page_daily_sanitized_candidate`
  strips query strings and fragments, then re-aggregates rows that collapse to
  the same safe path.
- `mart_marketing_franchise.franchise_ga4_form_reconciliation_monthly_candidate`
  compares property-level `generate_lead` events with saved website forms.
- `mart_marketing_franchise.franchise_native_export_arrival_candidate`
  checks for the two expected native export datasets and daily tables without
  referencing a dataset before Google creates it.

### Student-Growth Paid History

- `mart_cefa_growth_intelligence.input_student_growth_paid_monthly_direct_candidate`
  preserves every closed historical month exactly and replaces only the
  current month with the governed paid-media source, plus exact direct Google
  Inquiry Submit action detail.
- `mart_cefa_growth_intelligence.student_growth_paid_history_source_health_candidate`
  checks Google spend, Google inquiry actions, and Meta spend/inquiry evidence
  separately.
- `mart_cefa_growth_intelligence.student_growth_paid_history_health_candidate`
  compares the stale current input with the fresh parallel candidate.

## Validation Evidence

- All additive SQL passed BigQuery validation and deployment.
- Existing dashboard-facing object names were not altered.
- Candidate landing-page totals preserve source sessions and lead events:
  Canada `21,933` sessions / `201` leads; USA `10,059` sessions / `73` leads.
- Candidate landing paths containing `?` or `#`: `0`.
- Candidate property duplicate keys: `0`.
- Current July reconciliation through 2026-07-30:
  Canada `48` GA4 leads versus `47` forms, `pass`; USA `40` versus `35`,
  `fail` at a `14.3%` absolute delta.
- Both native franchise export datasets remain `pending`, with no hard failure
  before the 2026-08-02 provisioning gate.
- Current student-growth paid input is stale through 2026-07-19.
- The parallel candidate and each required source are current through
  2026-07-30.
- May and June spend/inquiry values are unchanged between current and
  candidate contracts. July is intentionally newer in the candidate.
- All six candidate assertion queries returned zero failure rows. The USA
  reconciliation failure remains visible in its monitoring view and is not
  hidden by an assertion pass.

## Promotion Gates

Do not replace existing dashboard or forecasting sources until:

1. both native franchise datasets and first daily tables arrive;
2. native event-level data proves or disproves the USA duplicate-event path;
3. the six candidate assertions compile and run in the Dataform workspace;
4. a scheduled materialization preserves each completed paid-history month
   before the direct rolling source ages out;
5. dashboard comparison shows no unintended total or grain change; and
6. rollback ownership and monitoring delivery are active.

## Remaining Work

- Prove the USA GA4 overcount at event level after native export arrival.
- Add hostname, event-name, and event-identity assertions against native GA4.
- Build the monthly materialization for the paid-history candidate. The view
  is safe for parallel QA but is not a durable historical loader by itself.
- Compile and run the six new assertions in Dataform; no production workflow
  or release configuration exists yet.
- Connect alert delivery for hard failures and stale sources.
- Move deployed warehouse/runtime source into a CEFA-controlled private
  repository before further Cloud Run redeployment.
