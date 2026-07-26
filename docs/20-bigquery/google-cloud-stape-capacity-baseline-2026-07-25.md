# Google Cloud And Stape Capacity Baseline

**Measured:** 2026-07-25  
**Project:** `marketing-api-488017`  
**Scope:** capacity and reliability planning, not invoice reconciliation

## Decision

The approved annual platform envelope is sufficient for the current CEFA
measurement roadmap with substantial headroom:

- quoted Google Cloud and BigQuery line: `3,377` in the quote currency;
- quoted server-side GTM line: `1,370` in the quote currency;
- combined quoted envelope: `4,747`;
- quote currency, taxes, implementation inclusions, and renewal terms remain
  Finance/procurement confirmations.

The `1,370` sGTM line must be reconciled against the Stape Business license
shown as `$83/month` or `$1,000/year`. It may include implementation or managed
support; it must not be assumed to be an additional Stape license.

## Measured Baseline

| Capacity area | Read-only evidence | Planning interpretation |
|---|---:|---|
| Durable BigQuery logical storage | `6.198 GiB` across `791` stored tables | Very small; storage is not a material budget risk |
| July BigQuery query volume through July 25 | `1.5459 TiB` billed | Approximately `$3.41 USD` after a fully available first `1 TiB` monthly allowance, or `$9.66 USD` before that allowance |
| July query jobs through July 25 | `52,594` | High job count but low data volume; orchestration should be simplified for reliability, not primarily for cost |
| Parent GA4 export | `236,655` April; `445,952` May; `251,530` June; `186,882` July through July 24 | Stape Business `5M` monthly allowance has ample planning headroom |
| Cloud Run estate | `11` jobs and `3` services | Current schedule-driven workloads are modest, but timeout loops must be prevented |
| Cloud Scheduler | `9` jobs; after the binder pause, `5` enabled and `4` paused | Scheduler cost is immaterial; paused jobs still count as billable jobs |
| Dataform | API enabled; existing QA foundation | Dataform itself is free; its BigQuery and Logging use is billed normally |
| Cloud Tasks and Workflows | APIs disabled | Keep disabled until the prepared queue/workflow implementation is ready |
| Pub/Sub | API enabled; inventory denied to the restricted audit identity | Admin inventory remains required before use |

At the official on-demand analysis price of `$6.25 USD/TiB`, even a sustained
tenfold increase over the July run rate would remain inside the annual Google
Cloud allowance before considering the other low-volume services. That is a
capacity scenario, not a forecast or invoice commitment.

## Operational Finding And Containment

The read-only GreenRope identity binder had entered a retry storm:

- `208` Form 4 identities were safely present in the restricted inbox;
- `201` were retryable because a GreenRope candidate was not yet available;
- zero opportunities were matched and zero GreenRope readbacks were confirmed;
- some rows had exceeded `200` attempts;
- recent binder runs repeatedly reached the `1,200` second timeout.

The schedule `cefa-parent-greenrope-identity-binder-15m` was paused on
2026-07-25. This pause affects only the read-only GreenRope matcher. Form 4
capture remains enabled; Gravity Forms, KinderTales, website conversions,
Google, Meta, and the already-paused CRM dispatchers were not changed.

The source now includes progressive retry cooldowns and a configurable
maximum of five GreenRope groups per run. Deployment is pending renewed human
Google Cloud authentication because the durable BigQuery service account
cannot stage Cloud Build source. The schedule must remain paused after
deployment until the GreenRope field and candidate path are confirmed.

## Durable Capacity Views

Source:
`tools/warehouse/cloud_cost_capacity_foundation.sql`

Objects:

- `cefa_governance.cloud_platform_budget_registry`
- `cefa_ops.vw_bigquery_usage_monthly`
- `cefa_ops.vw_bigquery_storage_current`
- `cefa_ops.vw_stape_parent_capacity_proxy_monthly`
- `cefa_ops.vw_measurement_platform_capacity_board`
- `cefa_ops.vw_parent_identity_binder_health`

The BigQuery USD field is an indicative analysis estimate. It does not include
all Cloud products, taxes, billing-account-level free-tier sharing, currency
conversion, negotiated pricing, or credits. The Stape view uses parent GA4
event rows as a planning proxy until Stape request logs are available.

The legacy `assert_bq_usage_guardrails` view previously failed when the
free-tier-oriented dashboard status became `stop`. That behavior conflicted
with the approved paid platform plan. It now flags only a material capacity
anomaly: at least `40 TiB` billed in the current month or at least `500 GiB`
of durable logical storage. The assertion is informational and must not
interrupt required measurement workloads.

## Remaining CEFA-Owned Work

1. Connect Cloud Billing export so actual service and SKU cost replaces the
   planning estimate.
2. Productionize the existing Dataform repository, releases, assertions, and
   workflow configurations. The first 15 source-controlled assertions now
   compile and pass in a non-production workspace; Git connection, runtime
   identity, releases, schedules, and transform parity remain.
3. Verify CEFA ownership and administrative recovery for the Stape Business
   workspace.
4. Export browser GTM baselines and build the Parent Stape container in
   non-production shadow mode.
5. Select and configure the first-party Parent tagging endpoint with the DNS
   owner.
6. Add approved alert destinations for failed jobs, stale data, assertion
   failures, delivery failures, and abnormal request growth.
7. Enable Cloud Tasks only when the offline-dispatch queue package and
   dead-letter runbook are ready.
8. Complete the administrator inventory for IAM, Secret Manager, Pub/Sub,
   Cloud Billing, and service ownership.

## External Dependencies

- GreenRope fields `cefa_event_id` and `cefa_form_entry_id`;
- confirmation of the KinderTales-to-GreenRope opportunity creation path;
- controlled Parent identity test after those fields exist;
- Stape workspace, container entitlement, and DNS ownership confirmation;
- approved notification destination and operational owner.
