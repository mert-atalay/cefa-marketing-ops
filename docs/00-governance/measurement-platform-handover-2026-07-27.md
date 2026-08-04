# CEFA Measurement Platform Handover

**Last updated:** 2026-08-04
**Owner:** CEFA marketing measurement
**Status:** Current handover entry point
**Repository:** `mert-atalay/cefa-marketing-ops`
**Repository visibility:** Public

## Purpose

This is the detailed handover a new CEFA employee, agency, vendor, developer,
or AI agent should read after the
[marketing operations context layer](./marketing-operations-context-layer.md)
and before changing conversion tracking, paid-media naming, Google Cloud,
BigQuery, Stape, WordPress tracking, or CRM activation.

It explains:

- what is live;
- which system owns each responsibility;
- where the canonical plans and contracts live;
- which identifiers and data layers must be preserved;
- which plugins and custom services are involved;
- what is approved, pending, blocked, or intentionally out of scope;
- how to continue the program without interrupting KinderTales or Synuma.

This is a routing and handover document. Detailed implementation documents
remain authoritative for their own workstreams.

## Read These In Order

1. [Marketing operations context layer](./marketing-operations-context-layer.md).
2. This handover.
3. [System and integration register](../70-growth-operations/system-and-integration-register.md)
   and [gap, risk and scenario register](../70-growth-operations/gap-risk-and-scenario-register.md).
4. [Measurement and activation program register](./measurement-and-activation-program-register-2026-07-23.md)
   for current status, blockers, sequencing, and production gates.
5. [Marketing and BI alignment final decision](../70-growth-operations/marketing-bi-alignment-final-decision-and-email-2026-07-27.md)
   for the Supabase/BigQuery boundary and parallel execution gates.
6. [Google Cloud and Stape measurement platform blueprint](../superpowers/plans/2026-07-25-google-cloud-stape-measurement-platform-blueprint.md)
   for the definitive target architecture and implementation phases.
7. [BigQuery marketing intelligence blueprint](../superpowers/plans/2026-06-12-bq-marketing-intelligence-blueprint.md)
   for the locked strategic warehouse, semantic, predictive, and activation
   direction.
8. [Data taxonomy and source map](./data-taxonomy.md) for systems, identifiers,
   event ownership, and question-to-source routing.
9. [Paid-media naming and copy standard](../40-naming-convention/cefa-paid-media-naming-and-copy-standard.md)
   before creating or changing campaigns, UTMs, copy, or object names.
10. The narrow implementation file linked from the relevant workstream README.

## Source-Of-Truth Hierarchy

When sources disagree, use this order:

1. Verified live system evidence.
2. Runtime code and current narrow implementation contract.
3. The context layer, this handover and the program register for
   cross-workstream routing and status.
4. The July 27 marketing/BI alignment decision for the Supabase boundary and
   parallel activation gates.
5. The July 25 Cloud/Stape blueprint for implementation architecture.
6. The June 12 BigQuery blueprint for strategic direction.
7. Dated implementation reports and historical phase documents.
8. Private CEFA source evidence and external platform guidance.

Never use an old screenshot, mutable campaign name, dashboard label, or local
scratch file as final truth when a stable ID or verified live source exists.

## Repository Boundary

This repository is public. It may contain:

- non-secret CEFA Conversion Tracking plugin code;
- redacted architecture and implementation contracts;
- event, naming, schema, and acceptance rules;
- aggregate operational status;
- non-sensitive tests and examples.

It must not contain:

- credentials, API keys, tokens, cookies, OAuth files, or service-account keys;
- raw Gravity Forms, KinderTales, GreenRope, Synuma, Mailchimp, or platform
  payloads;
- parent, child, franchise lead, employee, or vendor PII;
- private browser sessions or full platform exports;
- unrestricted Cloud Run, Dataform, infrastructure, Stape, GTM, or deployment
  runtime that CEFA intends to keep private.

The target architecture requires a CEFA-controlled private cloud runtime
repository for production Cloud Run, Dataform, infrastructure, deployment,
Stape manifests, and runbooks. Until that repository exists, private runtime
must not remain reproducible only from an untracked local folder or an old
container image.

## Business Flows And Ownership

### Parent inquiry

```text
cefa.ca
  -> Gravity Forms Form 4
  -> CEFA School Manager
  -> KinderTales business delivery

CEFA Conversion Tracking
  -> attribution and event identity
  -> neutral school_inquiry_submit
  -> web GTM
  -> GA4, Google Ads and Meta

Current first-party Stape route
  -> GA4 through edge.cefa.ca
  -> same neutral event and same cefa_event_id
  -> Google Ads and Meta server delivery only after deduplication QA
```

Rules:

- Form `4` is the authoritative parent inquiry record.
- School Manager owns school, program, day, and KinderTales delivery.
- The tracking plugin may improve attribution and event identity but must not
  replace School Manager business logic.
- Parent event identity is Form `4` field `32.4`.
- Parent attribution fields are `35-46`.
- Parent school joins use `school_uuid`, represented in the event payload as
  `school_selected_id`.

### Parent CRM lifecycle

```text
Form 4 event identity
  -> exact GreenRope opportunity identity
  -> prospective lifecycle change
  -> restricted BigQuery ledger and outbox
  -> Google secondary CRM-stage conversion
  -> Meta CRM-stage server event
```

Current approved stages:

- `tour_scheduled`;
- `tour_completed_candidate`;
- `crm_closed_won`.

These are secondary reporting signals. Existing website inquiry conversions
remain primary. No historical GreenRope snapshot may be uploaded as a new
conversion.

Current blockers:

- GreenRope opportunity fields `cefa_event_id` and `cefa_form_entry_id`;
- confirmation of the KinderTales-to-GreenRope opportunity path;
- controlled identity test;
- per-record platform eligibility decision;
- first legitimate Meta custom-event registration before reporting custom
  conversions can be created.

### Franchise Canada and USA

```text
Franchise website
  -> Gravity Forms 1 or 2
  -> existing franchise delivery plugin
  -> Synuma/SiteZeus

Website helper event
  -> web GTM
  -> property-specific GA4, Google Ads and Meta destinations

CEFA canonical attribution
  -> shadow beside GAConnector
  -> no field or CRM payload replacement yet
```

Rules:

- Franchise Canada and USA remain isolated from parent tracking and from each
  other.
- GAConnector remains the production attribution owner for fields `14-30`
  until the documented cutover gates pass.
- Synuma/SiteZeus remains the franchise business-delivery path.
- Stape may later add first-party server routing, but it does not replace
  Synuma.

Latest aggregate observation through 2026-07-26:

- canonical and ledger coverage was `14/16` eligible non-direct entries;
- Canada Form `1` coverage was `5/7`;
- paid core parity was `83.3%` for Canada Form `1`, `95.6%` for USA Form `1`,
  and `100%` for USA Form `2`;
- USA Form `1` had Synuma IDs for only `4/7` entries;
- GAConnector cutover is not approved.

## Neutral Event Contract

| Property | Form | Neutral website event | Business truth |
|---|---:|---|---|
| Parent `cefa.ca` | 4 | `school_inquiry_submit` | Saved Form 4 inquiry and KinderTales delivery |
| Franchise Canada | 1 | `franchise_inquiry_submit` | Saved inquiry and Synuma delivery |
| Franchise Canada | 2 | `real_estate_site_submit` | Saved site submission and Synuma delivery |
| Franchise USA | 1 | `franchise_inquiry_submit` | Saved inquiry and Synuma delivery |
| Franchise USA | 2 | `real_estate_site_submit` | Saved site submission and Synuma delivery |

Browser and server transports must use the same logical event and same event
identity. Do not invent duplicate event names merely to distinguish transport.

## Identity And Counting Model

Use separate keys for separate business grains:

| Key | Meaning |
|---|---|
| `cefa_event_id` | One website, form, CRM, or activation event |
| `form_entry_id` | One saved Gravity Forms entry |
| `parent_key` | One deterministically identified adult contact |
| `household_key` | One source-confirmed household relationship |
| `dependent_key` | One source-confirmed child, restricted and optional |
| `inquiry_key` | One legitimate saved inquiry |
| `opportunity_key` | One source CRM opportunity |
| `school_uuid` | Canonical CEFA school identity |
| Platform object IDs | Stable campaign/ad/ad-set/ad-group/asset-group handles |

Important cardinality rules:

- one parent may make multiple legitimate inquiries;
- one household may have multiple adults and children;
- one inquiry may involve several schools or downstream opportunities;
- promoted, selected, opportunity, and eventual operational school are
  separate concepts;
- technical duplicates are collapsed by event/form identity;
- legitimate repeat inquiries are not erased by parent-level deduplication;
- CRM platform conversion deduplication is one accepted event per
  `inquiry_key + canonical_stage`.

Raw parent and child PII remains in operational systems and restricted
processing. Normal marketing BigQuery tables use no-PII keys and facts.

## BigQuery And Google Cloud Structure

Project: `marketing-api-488017`.

| Layer | Role |
|---|---|
| Source landing | Source-faithful GA4, paid platform, forms, CRM and connector data |
| Restricted identity | HMAC identity bridges, bounded click-ID and eligibility evidence |
| Canonical raw | Normalized no-PII source facts |
| Staging | Replaceable cleaning and deduplication |
| Core | Stable dimensions, bridges and canonical facts |
| Intelligence | Diagnostics, forecasts, models and recommendations |
| Dashboard serving | Certified, backward-compatible reader contracts |
| Activation | Restricted audience and offline-conversion preparation |
| Governance/operations | Ownership, lineage, freshness, SLOs, runs and assertions |

Canonical dimensions and facts are listed in the
[Cloud/Stape blueprint](../superpowers/plans/2026-07-25-google-cloud-stape-measurement-platform-blueprint.md#8-bigquery-target-structure).

Current implementation status:

- full relevant Google Cloud and BigQuery capacity is approved;
- cost controls are informational and must not silently drop required data;
- an 18-assertion Dataform QA package is mirrored and committed in the cloud
  workspace, compiles with zero errors, and passed a full `18/18` cloud run;
- Cloud Run remains the current production orchestration layer;
- production Dataform Git/release/workflow configuration remains pending;
- Cloud Billing export, comprehensive alerts, queues, dead-letter handling,
  private runtime source control, and runbooks remain incomplete.

## Stape Business Status

CEFA has annual Stape Business for the Parent property. Parent hosting runs in
`CA East (Canada)` behind `edge.cefa.ca`. GA4 and Meta CAPI are now live through
the guarded Parent server container. Google Ads remains on its existing browser
conversion path; its server copy is staged and paused.

Verified through 2026-08-04:

- Parent server GTM `GTM-T7C46VM7` and first-party DNS/TLS/health;
- CEFA account 2FA, healthy billing, auto-upgrade, durable API-key rotation,
  and revocation of the disclosed predecessor;
- Stape Analytics, outgoing logs, one enabled alert recipient, and enabled
  hourly incoming `5xx`, outgoing `4xx`, and outgoing `5xx` alerts;
- published server version `9`, `CEFA | Parent | Meta CAPI Inquiry Submit Live
  | 2026-08-04`, with native GA4 client/tag, Client Name
  enforcement, anchored Parent-host guard, explicit event allowlist, IP
  redaction, first-party FPID support, and no CRM or franchise routes;
- current-token browser Preview HTTP `200`, intended health tag fire, GA4 HTTP
  `204`, and one independent Stape outgoing-log row for `GA4` status `204`;
- four-case no-preview routing proof with exactly two intended GA4 HTTP `204`
  deliveries and zero wrong-host or wrong-event deliveries;
- published web version `12`, `CEFA | Parent | GA4 via First-Party sGTM |
  2026-08-04`, established the first-party GA4 route;
- published web version `13`, `CEFA | Parent | Google Ads Event ID Dedup |
  2026-08-04`, added the existing event ID as Transaction ID on the existing
  Google Ads inquiry tag without changing its destination, value, trigger, or
  enhanced-conversion setting;
- published web version `15`, `CEFA | Parent | GA4 Lead Payload Guardrail |
  2026-08-04`, retains shared identity, school, program, value, currency and
  compact source context while reducing configured `generate_lead` parameters
  from `41` to the GA4 limit of `25`;
- clean live homepage proof: one `edge.cefa.ca` GA4 request, no direct browser
  GA collection request, and one Stape `PageView` delivery with HTTP `204`;
- server version `9` uses a strict Parent `generate_lead` route, live Meta CAPI
  with the exact browser custom-event name `Inquiry Submit`, paused native
  Google Conversion Linker and Google Ads server conversion tags, and a paused
  Meta test tag;
- direct Meta Test Events and an independent propagated sGTM transport test
  both returned one accepted event, no messages, matching event ID, and no
  generated `_fbp` value;
- three inspected Facebook outgoing requests returned HTTP `200`,
  `events_received=1`, and no messages; two occurred after production
  activation and align with lead/conversion rows, so they are likely
  legitimate production inquiries, while Events Manager deduplication proof
  remains open;
- a post-build health check and controlled non-conversion request both
  returned HTTP `200`;
- no conversion action, campaign goal, Gravity Forms, School Manager,
  KinderTales, CRM, franchise route, or existing dashboard contract was
  replaced.

Additive certified Parent reporting is also live:

- `mart_marketing.vw_parent_inquiry_certified_event`;
- `mart_marketing.vw_parent_inquiry_school_source_certified_daily`;
- `mart_marketing.vw_parent_inquiry_certified_qa_daily`;
- `mart_marketing.vw_parent_inquiry_measurement_model_dictionary`;
- `mart_cefa_growth_dashboard.dashboard_parent_inquiry_school_source_certified_daily_candidate`;
- `mart_cefa_growth_dashboard.dashboard_parent_inquiry_certified_qa_daily_candidate`.

These views count saved Form `4` entries, use Gravity's selected school and the
CEFA first-party attribution ledger, then add GA4 session last-click only by
exact event ID. Through 2026-08-03 they reconcile `3,689` source entries to
`3,689` event rows and `3,689` daily inquiries, with zero missing schools and
`3,331` (`90.3%`) exact GA4-eligible rows. They expose no direct PII or raw
click IDs and do not reproduce Meta/Google platform attribution windows.

Required design:

- one CEFA-owned Stape account;
- isolated Parent, Franchise Canada, and Franchise USA server containers or
  equivalent hard isolation;
- first-party endpoints;
- existing neutral event names;
- exact Meta `event_id` and Google transaction identity deduplication;
- web GTM retained for browser interaction capture;
- no KinderTales or Synuma dependency on Stape;
- no destination cross-talk;
- shadow reconciliation before promotion.

Current gaps:

- recovery-code custody and secondary administrator evidence;
- production rollback runbook;
- operational consent/CMP policy and advertising-destination consent gates;
- ongoing GA4 browser/server parity and destination-isolation monitoring;
- controlled Google duplicate-counting QA before unpausing its server tag;
- Meta Events Manager read-back for accepted production browser/server pairs;
- controlled Form `4` conversion continuity proof;
- Looker test-source and dashboard-owner QA for the additive certified report;
- separate Franchise Canada and Franchise USA container/endpoint builds.

## WordPress Tracking Plugin Inventory

The current read-only inventory is maintained in
[Live WordPress tracking plugin inventory](../10-conversion-tracking/live-wordpress-tracking-plugin-inventory-2026-07-27.md).

Key components:

- CEFA Conversion Tracking `0.6.4` on Parent and `0.6.3` on both franchise
  properties;
- CEFA School Manager `1.0.22` on parent;
- Gravity Forms `2.10.5` on all three properties;
- CEFA Franchise MCP Control on both franchise properties;
- WPCode/Insert Headers and Footers on all three properties;
- Gravity Forms Mailchimp on all three properties;
- Gravity Forms Webhooks and Zoho CRM add-ons on parent;
- Gravity Forms Google Analytics add-on on Franchise USA.

The franchise custom plugin versions differ between Canada and USA. That
difference must be understood before code is synchronized or replaced.

## Paid-Media Naming And Copy

Use the
[canonical paid-media naming and copy standard](../40-naming-convention/cefa-paid-media-naming-and-copy-standard.md).

Current state:

- Meta `NC1` is the live baseline;
- Meta `NC2` is a proposed planning/build convention;
- Google `GADS1` is a proposed planning/build convention;
- no broad live rename is approved;
- live object changes must use platform IDs, not name matching.

Strict copy rule:

- targeting may use search-intent terms such as `daycare`, `childcare`,
  `child care`, and `preschool`;
- visible CEFA parent/enrollment ad copy must not use those terms;
- visible copy must use `CEFA Early Years` and/or
  `CEFA Early Years School`.

## Current Gaps And Waiting Items

| Area | Gap | State |
|---|---|---|
| Public/private source control | CEFA private cloud runtime repository does not yet exist | `Blocked operational risk` |
| GreenRope identity | Two exact opportunity fields and path confirmation | `Blocked external` |
| Parent offline activation | Controlled identity and eligibility gates | `Active guarded` |
| Stape | Parent GA4 and Meta CAPI are live through server version `9`; web version `15` carries shared identity within the 25-parameter GA4 limit. Google server delivery remains paused | `Active guarded` |
| Parent certified reporting | Additive school/source/event, daily QA and measurement-model views reconcile Gravity truth to exact-ID GA4 context; candidate dashboard views are not connected to existing serving contracts | `Active guarded` |
| BI Supabase | Restricted zero-row BigQuery outcome inbox and v1 field contract exist; BI source grain, identifiers, history, lineage, freshness and source mappings remain unverified | `Interface ready; source verification pending` |
| Shared metric dictionary | Inquiry, tour, enrollment, attribution and school definitions are not jointly certified | `Partial` |
| Dataform | Production Git, runtime identity, releases and transform parity | `Active guarded` |
| Monitoring | Billing export, alerts, dead letters and complete runbooks | `Partial` |
| Franchise attribution | Coverage/parity below cutover gates | `Active guarded` |
| Franchise CRM delivery | USA Synuma lead-ID gaps | `Alert` |
| Naming | NC2/GADS1 remain planning candidates, not live rename approval | `Partial` |
| Master data | Some school/program/source crosswalks still need reconciliation | `Partial` |
| Parent omnichannel | KinderTales identity API/export and email provider inventory | `Pending later phase` |
| Mailchimp | Existing Form 4 feed needs purpose/eligibility review and minimization | `Pending` |

## Roadmap

### Continuous protection

Preserve website, KinderTales, Synuma, GTM, GA4, Google, Meta, dashboard, and
current conversion continuity throughout both tracks.

### Track A: Parent outcomes

1. Obtain GreenRope identity fields and run the controlled Parent test.
2. Resolve per-record eligibility and activate eligible secondary CRM outcomes
   after baseline, deduplication, diagnostics, and kill-switch gates pass.
3. Inspect BI Supabase read-only and agree the shared metric dictionary.
4. Map and approve the versioned Parent outcome contract and proof-of-concept
   record against the empty restricted BigQuery inbox.
5. Reconcile before any one-sender source-authority switch.

Track A does not wait for Stape.

### Track B: Website measurement

1. Verify Stape ownership, entitlement, domains and recovery access.
2. Maintain Parent GA4 and Meta routing, observe legitimate Meta deduplication,
   and complete the controlled Google duplicate-counting gate.
3. Promote the Google server route only after exact once-only proof.
4. Extend Stape to Franchise Canada and USA one property at a time.

Track B does not inherit production authorization from Track A.

### Shared spine

1. Create the CEFA private cloud runtime repository.
2. Complete source/service-account/schedule/secret inventory.
3. Connect Dataform to CEFA-controlled Git and establish environments.
4. Add production alerts, queues, dead-letter visibility and runbooks.
5. Investigate USA Synuma delivery gaps before any GAConnector cutover.

### Later

1. Unified parent journey and school-level reporting.
2. Approved audience activation.
3. Mailchimp and GreenRope email/journey ingestion.
4. Multi-child and repeat-inquiry journey analysis.
5. Predictive demand, capacity, creative and budget recommendations.
6. Phone-attribution discovery and controlled matched-market incrementality.
7. Value-based outcome optimization only from verified final enrollment truth
   after volume, identity, economics, reconciliation, and bidding gates pass.

## Change Procedure

Before changing a live system:

1. Identify the owning contract and stable IDs.
2. Record the current live state.
3. Run read-only or validation-only checks.
4. Define expected behavior, failure conditions and rollback.
5. Test in shadow, staging or no-send mode.
6. Reconcile form, CRM, browser, server, platform and warehouse evidence.
7. Promote one property, destination or workload at a time.
8. Update the narrow implementation doc.
9. Update the program register if status, ownership, blocker or sequencing
   changed.
10. Update the integration and gap/scenario registers when applicable.
11. Update the machine-readable context manifest.
12. Update the context layer or this handover only when the cross-workstream
    operating model changes.

## Handover Completion Checklist

- [ ] New owner can identify the business truth for each event.
- [ ] New owner can load the context manifest and locate each system,
      integration, gap and what-if scenario by stable ID.
- [ ] New owner can explain the Parent and Franchise delivery paths.
- [ ] New owner can locate all current event and naming contracts.
- [ ] New owner understands the public/private repository boundary.
- [ ] Runtime services, identities, schedules, secrets and alerts have named
      owners.
- [ ] GreenRope and KinderTales dependencies have vendor owners.
- [ ] Stape access, billing, domains, containers and recovery access are CEFA
      controlled.
- [ ] All production workloads are reproducible from governed private source.
- [ ] All dashboards identify their grain, source and freshness.
- [ ] No raw PII or credentials are present in GitHub.
