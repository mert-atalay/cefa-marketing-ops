# Franchise GA4 Native BigQuery Export Activation

**Activation date:** 2026-07-31
**Owner:** CEFA marketing measurement
**Status:** Datasets and daily tables live; Canada nonproduction-host exclusion pending

## Outcome

Native daily BigQuery export is now linked for both franchise GA4 properties
to CEFA Google Cloud project `marketing-api-488017` (`931391757152`). This
closes the configuration gap that previously left franchise GA4 dependent on
snapshot or Data API reporting inside the warehouse.

| Market | GA4 property | Included web stream | Expected BigQuery dataset | Link state |
|---|---|---|---|---|
| Franchise Canada | `259747921` | `properties/259747921/dataStreams/2689444693` / `https://franchise.cefa.ca` | `analytics_259747921` | One active link verified |
| Franchise USA | `519783092` | `properties/519783092/dataStreams/13294140647` / `https://franchisecefa.com` | `analytics_519783092` | One active link verified |

## Applied Settings

- BigQuery project: `marketing-api-488017` / `projects/931391757152`.
- Dataset location: `US`, matching the existing CEFA marketing warehouse.
- Daily export: enabled.
- Streaming export: disabled for the initial daily reporting cadence.
- Fresh Daily export: disabled.
- Advertising identifiers: not enabled.
- Stream scope: only the correct web stream for each property.
- Event exclusions: none; franchise exports retain full GA4 event evidence.

The existing parent property `267558140` and its BigQuery link were read for
reference only and were not changed. Campaigns, conversions, GTM containers,
GA4 events, key events, and website tracking were not modified.

## Verification Evidence

Preflight on 2026-07-31 confirmed:

- neither franchise property had an existing BigQuery link;
- neither `analytics_259747921` nor `analytics_519783092` existed in the
  target project;
- Canada had one web stream for `franchise.cefa.ca`;
- USA had one web stream for `franchisecefa.com`.

Post-write Admin API read-back confirmed:

- exactly one BigQuery link exists for each franchise property;
- both links target `projects/931391757152`;
- both use the `US` location and daily export;
- each link contains only its own property stream;
- neither link excludes events;
- streaming export remains disabled.

No Cloud IAM role was added or changed. The operation used a temporary,
Analytics-scoped CEFA user credential because the read-only GA4 automation
identity did not have the Cloud project role required to create a link. The
temporary credential file was removed after verification.

## 2026-08-04 Arrival Verification

Read-only BigQuery verification confirmed:

- `analytics_259747921` exists with five daily tables from `20260730` through
  `20260803`;
- `analytics_519783092` exists with four daily tables from `20260731` through
  `20260803`;
- Canada contained `2,245` production-host events and five `generate_lead`
  events with five distinct, non-missing event IDs and zero duplicate delta;
- USA contained `3,099` production-host events and one `generate_lead` event
  with one distinct, non-missing event ID and zero duplicate delta;
- Canada also contained `40` nonproduction-host rows: `28` from
  `cefafranchistg.wpengine.com` and `12` from
  `cefafranchdev.wpenginepowered.com`;
- USA contained one row with no hostname.

The datasets are live and usable for bounded evidence. Production warehouse
normalization must explicitly classify or exclude the Canada staging and
development hosts rather than blending them into franchise performance.

## Provisioning And Promotion Gate

At the final same-day check, Google had accepted and exposed both links but had
not yet created the two physical BigQuery datasets. New GA4 links can require
up to roughly 24 hours before the first dataset/table appears, and native
export does not automatically backfill dates before activation.

Current gate status:

1. Passed: both datasets exist in `marketing-api-488017` in `US`.
2. Passed: both datasets contain daily event tables.
3. Passed through `20260803`: the latest event date is advancing.
4. Partial: production hostnames are isolated by property, but Canada includes
   `40` nonproduction-host rows that must be excluded or separately classified.
5. Passed for the first observed lead rows: expected `generate_lead` events
   carry complete, unique event IDs with zero duplicate delta.
6. Pending: warehouse normalization and franchise marts must prefer the native
   exports prospectively while preserving older snapshot history and excluding
   nonproduction hosts.

Do not promote the native exports into production dashboard totals until the
hostname rule and downstream source-precedence checks pass.
