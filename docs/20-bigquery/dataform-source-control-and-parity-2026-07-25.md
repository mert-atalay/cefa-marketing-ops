# Dataform Source Control And Parity

**Verified:** 2026-07-25; expanded and reverified 2026-08-04
**Project:** `marketing-api-488017`  
**Repository:** `cefa-marketing-warehouse-qa` in `us-central1`

## Completed

- Reconstructed the exact source for the 12 existing Dataform assertion views
  from BigQuery metadata.
- Added three source-controlled assertions for:
  - quoted cloud budget-key uniqueness;
  - one-row measurement capacity board integrity;
  - Stape Parent planning-proxy utilization below `80%`.
- Replaced the obsolete free-tier `stop` assertion with an anomaly check at
  `40 TiB` billed in the current month or `500 GiB` durable logical storage.
- Added the Dataform project under
  `dataform/cefa-marketing-warehouse-qa/`.
- Created non-production workspace `codex-foundation-20260725`.
- Mirrored and committed the current 20-file Git QA package in workspace
  `codex-foundation-20260725`.
- Added three certified Parent inquiry assertions for entry uniqueness, school
  completeness and event-to-daily reconciliation.
- Compiled the expanded workspace with Dataform Core `3.0.0`:
  - compilation result `e5eda148-31bf-40bc-b90d-b5eec544ecf6`;
  - 18 assertion actions;
  - zero compilation errors.
- Ran two manual tagged proof invocations:
  - `foundation_qa`:
    `1785040052-923d5def-f69b-406c-b922-5ca824c06786`;
  - `existing_qa`:
    `1785040068-d9f75a61-b8f7-4b3a-b57a-18eac21521e2`.
- Both invocations succeeded.
- Ran the expanded `certified_reporting` tag successfully.
- Ran the complete cloud package successfully: `18/18` actions passed in
  workflow invocation
  `1785877278-a9d46eb5-0b06-4a49-bce6-1525ad47791b`.
- Cloud workspace read-back reports zero uncommitted files.

## Safety

- No Dataform release configuration was created.
- No Dataform workflow configuration or schedule was created.
- No Cloud Run production transform was replaced.
- No dashboard contract, campaign, conversion, GTM, CRM, WordPress,
  KinderTales, Synuma, Google, or Meta destination was changed.

## Remaining

1. Connect the Dataform repository to CEFA-controlled Git through Developer
   Connect or an approved machine credential.
2. Confirm the dedicated Dataform runtime service account and least-privilege
   BigQuery access.
3. Create development, staging, and production release contracts.
4. Add deeper source freshness, platform attribution-window, lifecycle
   deduplication, and prohibited-PII assertions incrementally.
5. Run Dataform in parallel with the Cloud Run production pipeline.
6. Promote only after output parity and rollback evidence pass.
