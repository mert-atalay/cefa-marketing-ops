# BigQuery And Google Cloud Measurement

**Last updated:** 2026-07-31
**Status:** Active governed workstream

## Start Here

1. [Measurement platform handover](../00-governance/measurement-platform-handover-2026-07-27.md)
2. [Measurement and activation program register](../00-governance/measurement-and-activation-program-register-2026-07-23.md)
3. [Definitive Google Cloud and Stape blueprint](../superpowers/plans/2026-07-25-google-cloud-stape-measurement-platform-blueprint.md)
4. [Locked BigQuery marketing intelligence blueprint](../superpowers/plans/2026-06-12-bq-marketing-intelligence-blueprint.md)
5. [Data taxonomy and source map](../00-governance/data-taxonomy.md)

The June blueprint is the strategic warehouse/intelligence anchor. The July
blueprint is the definitive implementation architecture. The program register
owns current status, blockers, and sequencing.

## Current Decision

- Reuse Google Cloud project `marketing-api-488017`.
- BigQuery remains CEFA's governed marketing measurement and intelligence
  layer.
- The approved program is not constrained to free tiers or minimum service
  footprints.
- Cost and capacity alerts are operational visibility, not permission to
  silently skip required tracking or data-quality work.
- Existing dashboard-serving contracts remain stable until replacements pass
  reconciliation and are explicitly promoted.
- No raw parent or child PII belongs in normal marketing datasets, logs,
  dashboards, or diagnostics.
- Production private cloud runtime belongs in a CEFA-controlled private
  repository, not this public repository.

## Target Data Layers

| Layer | Preferred surfaces | Responsibility |
|---|---|---|
| Source landing | GA4 export, `raw_google_ads`, `raw_meta_ads`, `raw_supermetrics`, `raw_website_forms`, `synuma_raw` | Source-faithful landing and bounded corrections |
| Restricted identity | `cefa_restricted`, `cefa_parent_activation_restricted` | HMAC identity, bounded click IDs and eligibility evidence |
| Canonical raw | `cefa_raw`, `raw_marketing` | Normalized no-PII facts |
| Staging | `staging_marketing` | Replaceable cleaning and deduplication |
| Core | `cefa_core` | Dimensions, bridges and canonical business facts |
| Intelligence | `cefa_marts`, `mart_cefa_growth_intelligence` | Diagnostics, features, forecasts and recommendations |
| Dashboard serving | `mart_cefa_growth_dashboard` | Certified reader contracts |
| Activation | Approved restricted activation datasets | Audience/offline payload preparation and audit |
| Governance/operations | `cefa_governance`, `cefa_ops`, `dataform_assertions` | Ownership, lineage, freshness, SLOs, runs and assertions |

Do not immediately rename or rebuild existing datasets. Register their target
roles first, preserve readers, and consolidate only after lineage and parity
are known.

## Canonical Identity

The warehouse distinguishes:

- event;
- form entry;
- adult parent/contact;
- household;
- optional source-confirmed dependent/child;
- inquiry;
- CRM opportunity;
- school;
- campaign and platform object.

Use the detailed
[parent identity and omnichannel contract](../superpowers/plans/2026-07-25-google-cloud-stape-measurement-platform-blueprint.md#parent-identity-and-omnichannel-journey-contract).

Normal marts may contain approved no-PII demand attributes such as program
interest, age band, start window, promoted school, and selected school.
Names, exact child dates of birth, addresses, notes, contact details, and raw
CRM payloads remain outside those marts.

## Current Implementation

| Area | State | Evidence / next gate |
|---|---|---|
| Capacity approval | `Verified` | Full relevant Google Cloud scope approved |
| Capacity baseline | `Verified` | [Google Cloud and Stape capacity baseline](./google-cloud-stape-capacity-baseline-2026-07-25.md) |
| Dataform QA | `Active guarded` | 15 assertions compile and proof runs passed |
| Dataform production | `Pending` | Git connection, runtime identity, release/workflow configs and transform parity |
| Franchise GA4 native exports | `Active guarded` | Canada `259747921` and USA `519783092` links were created and read back on 2026-07-31; first datasets/tables remain pending Google provisioning |
| Parent CRM lifecycle foundation | `Active guarded` | Restricted tables, capture, binder, poller, outbox, dispatcher and diagnostics built |
| Google CRM actions | `Verified` | Three secondary actions created and validation passed |
| Meta CRM events | `Active guarded` | Test Events passed; reporting custom conversions wait for first legitimate live event |
| Stape | `Approved` | Business plan available; access, DNS, containers and shadow routing pending |
| Cloud monitoring | `Partial` | Capacity board exists; billing export, alerts, queues/dead letters and runbooks incomplete |
| Private runtime source control | `Blocked operational risk` | CEFA private runtime repository still required |

## Current Documents

### Architecture and operations

- [Google Cloud and Stape capacity baseline](./google-cloud-stape-capacity-baseline-2026-07-25.md)
- [Dataform source control and parity](./dataform-source-control-and-parity-2026-07-25.md)
- [Franchise GA4 native BigQuery export activation](./franchise-ga4-native-bigquery-export-activation-2026-07-31.md)
- [Warehouse current-state snapshot](./warehouse-current-state-2026-05-03.md)
- [Dashboard source layer and rule registry](./dashboard-source-layer-greenrope-and-rule-registry-2026-05-03.md)

### Parent CRM activation

- [Parent CRM offline-conversion data contract](./parent-crm-offline-conversion-data-contract.md)
- [Parent CRM offline-conversion implementation report](../10-conversion-tracking/parent-crm-offline-conversion-implementation-report.md)
- [Parent CRM offline-conversion activation blueprint](../superpowers/plans/2026-07-23-parent-crm-offline-conversion-activation-blueprint.md)

### CRM and supporting sources

- [GreenRope metric definitions and API map](./greenrope-metric-definitions-and-api-map-2026-05-03.md)
- [GreenRope aggregate corrections](./greenrope-current-state-aggregate-corrections-2026-05-04.md)
- [Supabase data foundation setup](./supabase-data-foundation-setup-2026-05-03.md)

Older documents remain useful evidence but do not override the current
blueprints or program register.

## Dataform

The public QA package is:

```text
dataform/cefa-marketing-warehouse-qa/
```

It contains non-secret assertions and proof configuration. Production
transformations, release settings, service identities, secrets, and deployment
manifests belong in the future private runtime repository.

## Service Responsibilities

| Need | Default service |
|---|---|
| API extraction | Cloud Run job |
| HTTP webhook/collector | Cloud Run service |
| Stable SQL graph | Dataform |
| Exact deferred dispatch/retry | Cloud Tasks |
| One-to-many event fan-out | Pub/Sub |
| Multi-step orchestration | Workflows |
| Time trigger | Cloud Scheduler |
| Immutable files/build evidence | Cloud Storage |
| Credentials | Secret Manager |
| Images/releases | Cloud Build and Artifact Registry |
| Health and alerts | Cloud Monitoring and Logging |
| Metadata/lineage | Dataplex and governance tables |
| SQL-native prediction | BigQuery ML |

Use a service because its delivery semantics fit the workload, not because it
is free or fashionable.

## Production Gates

- Source totals reconcile.
- Dataform compiles and critical assertions pass.
- Event and platform transaction IDs are unique.
- Existing dashboards remain unchanged unless a contract change is approved.
- Runtime identities are least privilege.
- Freshness, delivery, failures and unexpected volume are observable.
- Every production service has an owner, runbook and rollback.
- Prohibited PII in marketing tables/logs equals zero.
- KinderTales and Synuma regressions caused by measurement equal zero.

## Public Repository Rule

This public folder may document schemas, redacted contracts, aggregate
evidence and non-secret QA. It must not receive private runtime copied from an
untracked local checkout. The private-runtime creation gap is tracked in the
program register and handover.
