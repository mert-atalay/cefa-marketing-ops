# Reference Data

This folder is for small, reviewable, machine-readable reference data used by the docs and future agents.

## Rules

- Prefer CSV or YAML for small canonical/reference tables.
- Include an adjacent README or header comment explaining source and date.
- Do not store secrets, PII, raw exports, or large platform dumps here.
- If a value is incomplete, use a clear marker such as `pending`; do not guess.

## Current Files

- [marketing-operations-context.json](./marketing-operations-context.json)
  - Status: `Active governed`
  - Scope: machine-readable routing for the CEFA Marketing Operations Hub,
    including canonical documents, business domains, system IDs, integration
    IDs, open-gap IDs and what-if scenario IDs.
  - Use: load this first when an agent or tool needs structured context, then
    open the linked Markdown contract for human detail.
  - Guardrail: this is a routing manifest, not live-system evidence and not
    production-write authority.
  - Validation: run
    `node tools/validate-marketing-operations-context.js`; CI runs the same
    contract.
- [cefa-meta-active-object-inventory-2026-04-05-to-2026-05-04.csv](./cefa-meta-active-object-inventory-2026-04-05-to-2026-05-04.csv)
  - Status: `Verified` for live Meta object IDs, current names, delivery window, spend, impressions, and clicks read through the repo-local CEFA Meta CLI.
  - Status: `Partial` for proposed NC2 names and keys because some ad-level values are inferred from incomplete visible names.
  - Scope: CEFA Early Learning `parent` and CEFA Franchisor `franchise` campaigns, ad sets, and ads that delivered from 2026-04-05 through 2026-05-04.
  - Use: active Meta object crosswalk for naming review, UTM planning, and conversion-tracking joins.
  - ID contract: `object_id` is the campaign ID when `object_level=campaign`, the ad set ID when `object_level=ad_set`, and the ad ID when `object_level=ad`. Ad set and ad rows also carry `parent_campaign_id`; ad rows also carry `parent_adset_id`.
  - Guardrail: this is normalized reference data, not a raw Meta export, not a secret source, and not approval to make live Meta changes.
- [cefa-meta-creative-build-manifest-template-2026-05-04.csv](./cefa-meta-creative-build-manifest-template-2026-05-04.csv)
  - Status: `Partial`
  - Scope: header-only template for future CEFA Meta creative-to-ad build/import rows.
  - Use: workbook, Google Sheet, or n8n manifest schema for mapping approved copy and creative assets to campaign/ad set/ad IDs, generated names, URL tags, QA, approvals, and post-import audit fields.
  - Guardrail: this is a template contract, not an import-ready file and not approval to make live Meta changes.
- [cefa-google-ads-active-object-inventory-2026-04-05-to-2026-05-04.csv](./cefa-google-ads-active-object-inventory-2026-04-05-to-2026-05-04.csv)
  - Status: `Verified` for live Google Ads object IDs, current names, delivery window, spend, impressions, clicks, conversions, and all conversions read through the Google Ads API.
  - Status: `Partial` for proposed GADS1 names and keys because campaign/ad group/asset group values are inferred from current names and need review before live rename.
  - Scope: CEFA $3000 `parent` and CEFA Franchisor `franchise` campaigns, ad groups, Performance Max asset groups, and ads that delivered from 2026-04-05 through 2026-05-04.
  - Use: active Google Ads object crosswalk for naming review, UTM planning, conversion-tracking joins, and future Search/PMax build manifests.
  - ID contract: `object_id` is the campaign ID when `object_level=campaign`, ad group ID when `object_level=ad_group`, asset group ID when `object_level=asset_group`, and ad ID when `object_level=ad`. Child rows also carry parent campaign and ad group fields where applicable.
  - Guardrail: this is normalized reference data, not a raw Google Ads export, not a secret source, and not approval to make live Google Ads changes.
- [cefa-parent-supabase-bq-outcome-contract-v1.csv](./cefa-parent-supabase-bq-outcome-contract-v1.csv)
  - Status: `Approved interface; source mappings pending BI verification`
  - Scope: minimum record-level Parent business outcomes from BI Supabase to
    the restricted BigQuery activation boundary.
  - Use: one stable contract for parent, household, dependent, repeat-inquiry,
    multi-school, opportunity, enrollment, correction, lineage, and timestamp
    semantics without copying raw parent or child data into marketing tables.
  - Guardrail: `pending_source_mapping` and `blocked_external_identity` rows
    must not be guessed or treated as production-ready.

## Planned Files

- `schools.csv`
- `programs.csv`
- `paid-media-accounts.csv`
- `conversion-events.yaml`
