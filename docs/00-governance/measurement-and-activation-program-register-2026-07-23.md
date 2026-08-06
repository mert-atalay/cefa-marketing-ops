# CEFA Measurement And Activation Program Register

**Register date:** 2026-08-06
**Owner:** CEFA marketing measurement
**Status vocabulary:** `Verified`, `Active guarded`, `Approved`, `Pending`,
`Blocked`, and `Reference only`

## Purpose

This is the operational control page for CEFA conversion tracking, attribution,
marketing data engineering, and platform activation. It records:

- what is live now;
- what CEFA has approved;
- what is still being built;
- what is waiting on an external dependency or decision;
- which system owns each responsibility;
- which acceptance gates must pass before production cutover.

Detailed implementation documents remain authoritative for their own
workstreams. This register is the cross-workstream status and sequencing
authority. Update it when a major dependency, deployment state, vendor scope,
or production gate changes.

## Non-Negotiable Boundaries

1. Parent inquiry truth starts with Gravity Forms Form `4`.
2. CEFA School Manager continues to own Form `4` business delivery to
   KinderTales. Tracking work must not change its program, school, day, or CRM
   delivery behavior.
3. GreenRope is the approved parent CRM lifecycle source for the current
   offline-conversion project. It does not replace KinderTales.
4. Franchise Canada and Franchise USA remain separate from the parent path.
   Their existing GAConnector and Synuma/SiteZeus production flow stays in
   place until a documented cutover passes.
5. Website inquiry/application conversions remain primary. New CRM-stage
   conversions launch as secondary reporting signals and are not used for
   bidding without a later explicit decision.
6. The same `cefa_event_id` must be preserved across browser, server, form,
   CRM, warehouse, Google, and Meta paths where the event is the same.
7. Browser and server copies of one event must deduplicate. No tool may create
   a second business conversion merely because it has a different transport.
8. No raw parent or child PII belongs in marketing BigQuery tables, logs, or
   diagnostics. Restricted identity processing follows the approved HMAC and
   transient hashing contracts.
9. Existing dashboard contracts do not change until reconciliation passes and
   the replacement is explicitly promoted.
10. Supabase is CEFA's reported consolidated Parent business-data layer.
    BigQuery remains the marketing measurement, intelligence, and activation
    layer. The normal interface contains minimum record-level outcomes and
    certified summaries, not complete operational records or raw PII.
11. Reusable contracts may leave CEFA only as legally approved schema and code
    patterns. A future external product requires a separate private
    repository, cloud project, identities, secrets, datasets, runtime,
    destinations, billing boundary, and customer data plane. CEFA row-level
    data and credentials are not product assets or default benchmarks.

## Executive Status

| Workstream | State | Current reality | Next gate |
|---|---|---|---|
| Parent website attribution | `Verified` | CEFA Conversion Tracking `0.6.4` is live on Parent. It refreshes a consumed browser UUID after one successful submission while preserving validation retries; canonical Form `4` writeback, School Manager and KinderTales remain unchanged | Continue production monitoring |
| Parent website conversions | `Active guarded` | `school_inquiry_submit` still feeds the existing browser destinations. GA4, Meta CAPI `Inquiry Submit` and Google Ads server `Inquiry Submit_ollo` now run through Parent sGTM with the same Form `4` event ID used by the browser tags. The 2026-08-05 controlled saved Form `4` test passed transport and identity read-back. The overlapping legacy Meta Gateway route was isolated from the parent dataset; post-change browser and direct-CAPI tests passed | Monitor the first full post-change day for Meta browser/server transport parity and review Google conversion diagnostics after platform lag |
| Franchise attribution replacement | `Active guarded` | CEFA attribution and ledger run in shadow beside GAConnector. Through 2026-07-26 canonical/ledger coverage was `14/16` eligible non-direct entries; Canada Form `1` was `5/7`, and USA Form `1` had Synuma IDs for only `4/7` entries | Resolve USA delivery alert, improve evidence/parity, approve field mapping and rollback |
| Parent CRM offline conversions | `Active guarded` | Restricted BigQuery, capture, binder, poller, dispatcher, diagnostics, three Google actions, and three Meta test events are built; production sending is disabled; the capture schedule remains active while the no-value GreenRope binder retry loop is paused | Deploy binder backoff/group cap, then wait for GreenRope fields, controlled identity test, eligibility decision, and production activation |
| Google CRM-stage destinations | `Verified` | Three secondary, non-biddable actions exist and all passed Data Manager `validateOnly=true` | First eligible prospective CRM outcome |
| Meta CRM-stage destinations | `Active guarded` | All three custom server events passed Meta Test Events | First legitimate live event must enter Meta's registry before reporting custom conversions can be created |
| BigQuery and Google Cloud foundation | `Active guarded` | CEFA may use the full relevant Google Cloud and BigQuery capability set in `marketing-api-488017`; quoted budgets and live capacity views are registered, and current volume is comfortably inside the approved envelope | Connect Cloud Billing export, productionize Dataform, reconciliation assertions, alerts, queues, lifecycle integrations, and runbooks |
| Dataform | `Active guarded` | Git and the committed cloud workspace contain the same 18 assertions. Cloud compilation produced zero errors and the full package passed `18/18`; Cloud Run remains the production orchestrator and no Dataform production schedule was created | Connect governed Git/runtime releases, then establish dev/staging/prod workflows |
| Stape Business sGTM | `Active guarded` | Parent Stape Business runs in `CA East (Canada)` behind healthy `edge.cefa.ca`. Web version `15` preserves shared identity within GA4's 25-parameter limit. Server version `13` keeps guarded GA4, Meta CAPI, Google Conversion Linker and Google Ads Inquiry Submit live. The exact-event canary passed and was removed. The parent dataset is excluded from the overlapping legacy Meta Gateway, while Franchise USA remains connected there. Hourly incoming `5xx`, outgoing `4xx` and outgoing `5xx` alerts plus one recipient are enabled | Continue first-full-day destination parity monitoring and Google conversion diagnostics |
| Parent certified school/source reporting | `Active guarded` | Six additive non-PII BigQuery views now provide event, daily, daily-QA, measurement-model and candidate dashboard contracts. Through 2026-08-03, `3,689` source entries equal `3,689` event-view and daily-report inquiries; school completeness is 100% and exact GA4 eligibility is `3,331` (`90.3%`) | Connect only to a Looker test source, review visible identity/source exceptions, and obtain dashboard-owner approval before any serving-contract promotion |
| BI Supabase and marketing boundary | `Partial` | A restricted zero-row `parent_business_outcome_inbox` and machine-readable v1 contract now define the minimum Parent outcome interface without raw PII. The authorized Supabase connector sees only two inactive non-BI projects; the BI operational project's schema, grain, identity, history, timestamps, freshness, lineage and source mappings remain unavailable | BI read-only inspection, source mapping, shared metric dictionary and one proof-of-concept outcome record |
| Parent omnichannel identity and email | `Approved` | The blueprint now separates adult, household, child, inquiry, opportunity, and school identity and registers Mailchimp plus GreenRope email/journey evidence as a later read-only phase | Complete core identity first, then inventory provider APIs, mappings, timestamps, and totals |
| Unified Cloud and Stape platform | `Approved` | Definitive implementation architecture, service responsibilities, business outputs, foundation plus seven delivery phases, and acceptance board are documented | Start the private-runtime, inventory, Stape-access, endpoint, and Dataform foundation sprint |
| Reusable data-contract readiness | `Approved` | Existing identity, semantic, activation, predictive and agent-safe foundations will be extended with three measurement truth lenses, structured conversation facts, capacity guardrails, action-to-outcome learning, model eligibility and an external-export firewall | Version the contracts and assertions, then prove them with synthetic data in a separate empty environment; no CEFA data sharing or external runtime is authorized |
| Public/private source control | `Blocked operational risk` | This GitHub repository is public while material private warehouse/runtime work remains local or deployed from historical artifacts | Create CEFA-controlled private runtime repository and migrate reproducible non-secret runtime without exposing credentials or PII |
| Marketing operations context layer | `Verified` | Canonical context, system/integration register, gap/scenario register and machine-readable manifest now cover `39` systems, `40` integration IDs, `27` open-gap IDs and `27` what-if scenarios | Keep all four surfaces synchronized with narrow implementation evidence |

## Immediate Waiting List

| Dependency | Owner | Why it is required | What happens after it is complete |
|---|---|---|---|
| GreenRope opportunity field `cefa_event_id` | GreenRope account owner/admin or vendor | Stores the exact Form `4` event identity on the opportunity | Binder write/read-back test |
| GreenRope opportunity field `cefa_form_entry_id` | GreenRope account owner/admin or vendor | Confirms the matched Gravity Forms entry | Controlled end-to-end identity test |
| KinderTales-to-GreenRope opportunity path | KinderTales/GreenRope vendor | CEFA knows WordPress creates the KinderTales inquiry but must confirm whether that request also creates the GreenRope opportunity | Map both exact IDs through the existing vendor path or approve the idempotent CEFA worker |
| Controlled parent inquiry | CEFA measurement owner | Proves Gravity Forms, GreenRope, KinderTales, and existing conversions agree | Enable eligible prospective lifecycle processing |
| Per-record platform eligibility decision | CEFA | Runtime currently fails closed when eligibility is unknown | Enable platform dispatch only for approved records |
| Meta live custom-event registration | Meta, triggered by first legitimate eligible outcome | Test Events do not currently expose the event type to reporting custom-conversion creation | Create three reporting-only custom conversions |
| Stape recovery and secondary administrator evidence | CEFA | 2FA, API-key rotation, billing, auto-upgrade, analytics, outgoing logs, alert recipient and three monitoring rules are verified. Recovery-code custody and secondary administrator access are not visible through the API | Record CEFA-controlled recovery custody and backup administrator without exposing secrets |
| Parent sGTM conversion-route expansion | CEFA measurement owner | Completed for Parent under server version `13`: GA4, Meta CAPI, Google Conversion Linker and Google Ads Inquiry Submit are live behind strict Parent event guards. The controlled Form `4` test proved one saved entry and exact shared identity across the signed collector and all server destinations. The legacy parent Meta Gateway overlap was removed and post-change browser/direct-CAPI checks passed | Complete the first-full-day Meta receipt watch and Google post-lag diagnostics; then repeat the governed pattern independently for franchise properties |
| BI Supabase read-only schema and pipeline inspection | BI/digital transformation owner | The CEFA-authorized connector cannot see the operational BI project. Inspection must confirm Parent record grain, identifiers, history, timestamps, lineage, freshness, corrections and current pipeline behavior | Map and approve the deployed zero-row Supabase-to-BigQuery outcome contract |
| Shared Parent metric dictionary | BI and marketing intelligence owners | Prevents Power BI and marketing reporting from defining inquiry, tour, enrollment, attribution and school ownership differently | Certify the minimum feed in both directions and name metric owners |
| Franchise shadow evidence and Synuma review | CEFA measurement owner | GAConnector must not be replaced on sparse or delivery-uncertain evidence | Approve, extend, or reject franchise cutover |
| CEFA private cloud runtime repository | CEFA GitHub/Cloud owner | Production Cloud Run, Dataform, infrastructure, Stape manifests, deployment and runbooks must not depend on untracked local files | Connect governed private source to build/release workflows |
| KinderTales identity/lifecycle API contract | KinderTales/School Manager owner | Stable inquiry, adult, household, child, school, program, and lifecycle IDs are needed for the later multi-child omnichannel model | Build restricted HMAC relationships without raw child PII |
| Form 4 Mailchimp feed minimization | CEFA marketing/website owner | Current active feed maps exact child DOB, address, phone, email, and parent name and shows no configured feed opt-in condition | Back up, confirm purpose/eligibility, minimize fields, then add read-only API/webhook journey ingestion |

## Approved Tooling And Commercial Register

The values below record the decision evidence supplied to the project. Finance
or procurement remains authoritative for invoices, taxes, term dates, and
renewals.

| Item | Approved reference | Intended use | Registration status |
|---|---:|---|---|
| BigQuery + Google Cloud data and activation development | `$3,377` quoted line | Complete and harden CEFA's existing marketing data and intelligence foundation using the relevant Google Cloud capability set | Approved and available; not restricted to free tiers and not subject to a separate cost-approval gate |
| Stape Business | `$83.33/month` equivalent, billed `$1,000/year`, up to `5M` requests/month | Managed sGTM hosting, up to 20 domains, 10-day logs, five monitoring rules, first-party routing and server-side destination delivery | Parent annual Business paid and API-verified; hosting runs in Canada; Parent GA4, Meta CAPI and Google Ads server conversion routing are live under strict guards |
| Separate server-side GTM quoted line | `$1,370` quoted line | Implementation and/or managed service associated with Stape/sGTM | Commercial contents must be reconciled with the `$1,000/year` Stape license to prevent duplicate billing |

The approved Stape Business features are capabilities, not automatic
production permissions. Custom Loader, Cookie Keeper, Enricher, File Proxy,
request delay, scheduled requests, and IP blocking must each be enabled only
when they serve an approved tracking requirement and pass QA.

## Capacity And Cost Decision

**Decision date:** 2026-07-24

- CEFA has approved buying Stape Business for the Parent rollout. The Parent
  server GTM and Stape hosting containers were created on 2026-07-28, and the
  hosting container is running in `CA East (Canada)`. Annual Business payment
  and entitlement were API-verified on 2026-07-28; no additional program
  decision is required. First-party DNS, routing, parity, deduplication, and
  rollback remain required before production use.
- Google Cloud and BigQuery implementation is not constrained to free tiers,
  free quotas, or the smallest possible service footprint.
- A new Google Cloud service, paid BigQuery feature, larger runtime, increased
  query volume, or higher-frequency schedule does not require a separate
  cost-only approval when it directly supports this approved measurement,
  intelligence, reliability, or activation program.
- Billing dashboards and anomaly alerts remain informational operational
  controls. They must not silently throttle, skip, sample, or disable required
  tracking and data-quality workloads merely to preserve a free allowance.
- This approval does not permit an unrelated second warehouse, uncontrolled
  duplication, raw-PII expansion, autonomous campaign changes, or bypassing
  QA, security, privacy, destination, and rollback gates.

### Measured capacity, 2026-07-25

- Durable BigQuery storage: `6.198 GiB`.
- July BigQuery analysis through July 25: `1.5472 TiB` billed and an indicative
  `$3.42 USD` after a fully available first `1 TiB` monthly allowance.
- Parent GA4 event-row proxy through July 24: `186,882`, or `3.74%` of the
  Stape Business `5M` monthly request allowance.
- The approved platform envelope is sufficient with substantial headroom.
  Current delivery risk is operational ownership and integration readiness,
  not raw infrastructure capacity.
- Capacity source of truth:
  [Google Cloud and Stape capacity baseline](../20-bigquery/google-cloud-stape-capacity-baseline-2026-07-25.md).

## Target Architecture

```text
Parent website
  -> CEFA Conversion Tracking + web GTM
  -> Gravity Forms Form 4
       -> School Manager -> KinderTales
       -> exact identity -> GreenRope
  -> first-party Stape sGTM endpoint
       -> GA4
       -> Google Ads website conversions
       -> Meta Pixel/CAPI with event_id deduplication

GreenRope prospective lifecycle
  -> Cloud Run poller/webhook
  -> restricted BigQuery lifecycle ledger and outbox
  -> Google secondary CRM-stage conversions
  -> Meta CRM-stage server events

KinderTales + GreenRope
  -> BI-owned Python pipeline
  -> Supabase consolidated Parent business data
  -> minimum record-level outcome contract
  -> BigQuery reconciliation and guarded activation

BigQuery certified marketing facts
  -> Supabase / Power BI reporting contract

Mailchimp campaigns/journeys + GreenRope email/customer journeys
  -> read-only API extraction and signed webhooks
  -> restricted contact tokenization and identity bridge
  -> no-PII delivery, engagement and journey facts
  -> Parent omnichannel reporting
  -> later separately approved email/audience activation

Franchise Canada and USA
  -> existing website/GTM/GAConnector/Synuma production flow
  -> CEFA canonical attribution shadow
  -> later first-party sGTM path with property and destination isolation

All approved source facts
  -> BigQuery
  -> Dataform transformations and assertions
  -> certified reporting, intelligence, and activation contracts

Versioned safe schemas and decision logic
  -> synthetic portability test in a separate empty environment
  -> later separately approved external runtime
  -> never CEFA rows, credentials, destinations, or private runtime
```

## Stape Business Implementation Contract

### Required design

- CEFA owns the Stape account, billing relationship, GTM server containers,
  templates, custom domains, and administrative access.
- Use first-party endpoints. Proposed names must be checked against existing
  DNS before creation; examples are `metrics.cefa.ca` and equivalent
  first-party endpoints for each franchise property.
- Parent, Franchise Canada, and Franchise USA must remain isolated by
  hostname, event taxonomy, GA4 property, Google destination, Meta dataset,
  form identity, and debug evidence. One Stape account may manage them, but
  traffic cannot cross destinations.
- Keep the web GTM layer for browser interaction capture. sGTM is an additive
  processing and delivery layer, not a blind replacement.
- Forward the existing neutral event names. Do not invent parallel events to
  distinguish browser and server transport.
- Preserve the same `cefa_event_id` as Google transaction/dedup identity and
  Meta `event_id` when browser and server represent the same conversion.
- Keep parent School Manager/KinderTales and franchise Synuma/SiteZeus outside
  the sGTM critical path.
- Carry consent/eligibility state through the request. Server-side transport
  must not convert an ineligible event into an eligible event.
- Build consent-state plumbing and destination gating now. CMP procurement
  remains deferred; user-data matching, Customer Match, audience delivery, and
  other consent-dependent features stay disabled until separately approved.
- Use approved user-data fields only. Hashing, redaction, logging, retention,
  and destination rules must be documented before enhanced matching is
  enabled.

### Control and automation contract

- Use the direct Stape API as the canonical machine interface for container,
  subscription, domain, power-up, usage, analytics, monitoring-rule, and
  delivery-health inventory and approved automation.
- Use Stape MCP only as a supervised operator convenience. It is write-capable,
  must stay disabled by default, and is not the source of truth.
- Use the GTM MCP or GTM API for workspaces, clients, tags, triggers,
  variables, templates, environments, versions, and permissions inside the
  Google server container. The Stape API does not replace GTM configuration.
- Treat Stape API keys as full-account credentials until narrower scopes are
  documented and verified. Store durable keys in Secret Manager; never put
  them in Git, BigQuery, chat, shell history, GTM, or an inline MCP config.
- Record sanitized desired state and read-back evidence in the private runtime
  repository. API/MCP writes require explicit scope, preview or validation
  where supported, read-back, change evidence, and rollback.
- Poll the API into restricted non-PII operational tables for container
  inventory, domain health, usage, monitoring configuration, and aggregate
  delivery health.
- Business includes 10-day logs but not automatic export to Google Cloud
  Storage. Do not design durable raw-log retention around a Business feature
  that does not exist; consider Enterprise only if full log export becomes a
  proven requirement.

### Rollout sequence

1. Inventory current web GTM tags, destination IDs, event IDs, consent inputs,
   custom scripts, WordPress attribution, and existing CAPI behavior.
2. Create the Parent Google Tag Manager server container and record its
   container configuration.
3. Create the CEFA-owned Stape account/container, purchase Parent Business,
   and verify billing, recovery, region, entitlement, and administrators.
4. Create the Stape API key through the secure credential flow; read back and
   register the container, subscription, usage, domains, power-ups, and
   monitoring baseline.
5. Configure first-party test endpoints and server containers without
   changing production destinations.
6. Route page and non-conversion events in debug/shadow mode.
7. Add GA4 server routing and reconcile client/server sessions and event
   parameters.
8. Add Google Ads and Meta conversion routes using the existing neutral
   events and exact deduplication IDs.
9. Run controlled Form `4`, Franchise Canada Form `1`, and Franchise USA Form
   `1` tests. Do not create business leads merely for infrastructure QA unless
   the test can be clearly excluded.
10. Compare browser-only, server-received, destination-received, form, CRM, and
   warehouse totals.
11. Promote one property at a time with a documented rollback.
12. Remove a browser destination tag only if its server replacement is proven
    and deduplicated. Do not remove the browser event/data layer itself.

### Acceptance gates

- First-party endpoint and DNS/TLS health pass.
- No parent/franchise hostname or destination cross-talk.
- Existing website conversion fires once.
- Browser/server duplicate conversions equal zero.
- Event ID is present and stable across all copies of one event.
- Required school, form, campaign, source, click-ID, landing-page, and
  referrer fields reconcile to the form and canonical attribution record.
- Meta Pixel/CAPI deduplication is confirmed in Events Manager.
- Google Ads website conversion diagnostics show the intended source and no
  duplicate action.
- GA4 event names and key parameters remain compatible with current reports.
- No KinderTales or Synuma delivery regression.
- No prohibited PII appears in Stape logs, BigQuery, Cloud Logging, GTM debug
  exports, or documentation.
- Monitoring, access inventory, configuration export, change log,
  request-capacity alert, and rollback runbook exist.

## BigQuery And Google Cloud Development Contract

### Keep and extend

- Reuse project `marketing-api-488017`.
- Use the full relevant Google Cloud capability set when it improves
  correctness, durability, observability, delivery, analysis, or maintainability.
  Approved examples include BigQuery, BigQuery Data Transfer Service, Dataform,
  BigQuery ML, Gemini in BigQuery, Cloud Run, Cloud Run jobs, Cloud Functions,
  Scheduler, Pub/Sub, Cloud Tasks, Eventarc, Workflows, Cloud Storage, Secret
  Manager, Cloud Logging/Monitoring, Dataplex/metadata governance, and Vertex
  AI when BQ-native functions are insufficient.
- Keep BigQuery as marketing measurement and intelligence truth.
- Keep Cloud Run for API extraction, webhooks, custom processing, offline
  activation, and backward-compatible refresh entrypoints.
- Move stable BigQuery SQL transformations into Dataform incrementally.
- Keep Secret Manager as the credential boundary.
- Use Cloud Scheduler for explicit, observable schedules at the frequency
  required by the source and business SLA.
- Use Pub/Sub or Cloud Tasks only where asynchronous delivery, retries,
  fan-out, or dead-letter handling is required. Choose the service by delivery
  semantics, not by free-tier availability.
- Use Workflows, Eventarc, or Cloud Functions when they remove material
  orchestration or event-routing complexity; do not force every workload into
  Cloud Run.
- Preserve existing dashboard-safe contracts until promoted replacements
  reconcile.

### Required deliverables

- Source and transformation inventory with owner, schedule, service account,
  destination, freshness expectation, retry policy, and volume class.
- Dataform repository/release/workflow configuration tied to Git.
- Assertions for freshness, uniqueness, row counts, null safety, spend
  reconciliation, lead reconciliation, stage deduplication, and dashboard
  compatibility.
- Cloud Monitoring alerts for failed jobs, stale sources, failed assertions,
  delivery failures, quota pressure, abnormal usage, and unexpected volume.
- Idempotent queues and dead-letter visibility for webhook or activation work
  that requires retries.
- Least-privilege IAM and secret-level access.
- Artifact-to-commit traceability, deployment runbooks, rollback procedures,
  and a CEFA-owned handoff.
- Bounded retention and partitioning, especially for click IDs and restricted
  activation data.
- A deterministic identity model that preserves separate adult contacts,
  households, children, inquiries, CRM opportunities, and school interests
  without copying raw parent or child PII into marketing tables.
- Read-only Mailchimp and GreenRope email/journey contracts before any
  audience, profile, tag, automation, or journey write is considered.
- No duplicate warehouse, disconnected Google Cloud project, parallel school
  registry, or vendor-only source repository.

### Promotion gates

- Dataform compiles and all critical assertions pass in parallel.
- Source totals reconcile with the existing production pipeline.
- Dashboard outputs remain unchanged unless an approved contract changes.
- Service health, quotas, request volume, freshness, and failure rates are
  observable and do not silently drop required data.
- Runtime identities can access only their required datasets, jobs, queues,
  and secrets.
- Every production service has monitoring, failure ownership, and rollback.

## Parallel Build Board

Track A and Track B run in parallel. Each has its own production gate. Shared
platform work supports both tracks but does not force one track to wait for the
other.

| Lane | Work package | Current state | Exit condition |
|---|---|---|---|
| Continuous protection | Preserve current website, KinderTales, Synuma, CRM and dashboard paths | `Verified` | No regression during any rollout |
| Track A - outcomes | Create GreenRope identity fields and run the controlled Parent read-back | `Blocked` on vendor fields | Exact Form `4`/GreenRope identity; KinderTales succeeds; existing conversions fire once |
| Track A - outcomes | Activate eligible secondary GreenRope CRM outcomes | `Active guarded` | Eligibility, baseline, deduplication, platform validation, diagnostics and kill-switch gates pass |
| Track A - Supabase | Inspect BI Supabase and map the deployed versioned Parent outcome contract | `Partial`; empty restricted inbox and v1 contract ready, source verification pending | Record grain, identifiers, history, timestamps, lineage, freshness and proof-of-concept record pass |
| Track A - Supabase | Reconcile and optionally promote Supabase as the consolidated outcome source | `Pending` | Direct/Supabase parity, one sender, accepted-ID reconciliation and rollback owner pass |
| Track B - website | Buy Parent Business and verify Stape/API/GTM control planes, domains and routing architecture | `Active guarded`; Business, Canada hosting, first-party endpoint, 2FA, durable API key, analytics, outgoing logs, alert recipient and three enabled error rules are verified | Recovery custody and secondary administrator evidence |
| Track B - website | Build Parent Stape in shadow, then repeat by franchise property | `Parent complete, franchise pending`; Parent web version `15` and server version `13` are live. GA4 routing, payload limit, endpoint isolation, Meta and Google transport, shared identity and rollback points pass | Finish Parent operational read-backs, then independently build each franchise property |
| Track B - website | Promote Stape conversion routing one property at a time | `Parent active guarded`; Parent GA4, Meta and Google server routes are live under strict triggers. Franchise properties remain separate work | Monitor once-only delivery, platform diagnostics and rollback readiness for Parent; apply the same gates separately to each franchise property |
| Shared spine | Certified Parent school/source reporting | `Active guarded`; additive candidate views reconcile 3,689/3,689/3,689 and expose GA4 exceptions without PII | Looker test connection, exception review and explicit dashboard serving-contract approval |
| Shared spine | Dataform productionization | `Active guarded` | Git, runtime identity, releases, workflow configs, assertions and transform parity pass |
| Shared spine | Monitoring, queues, dead letters and runbooks | `Active guarded` | Alerts, replay, Cloud Billing export, failure ownership and rollback pass |
| Shared spine | CEFA private runtime source consolidation | `Blocked operational risk` | Reproducible Cloud Run, Dataform, infrastructure, Stape and runbook source exists without secrets |
| Existing guarded work | Franchise GAConnector decision | `Active guarded` | Evidence and Synuma gates determine cutover or continued coexistence |
| Later phase | Parent multi-entity identity and email/journey inventory | `Approved`/`Pending` | Deterministic relationships, provider reconciliation and no-PII contracts pass |
| Later phase | Reusable measurement, conversation, capacity and action-to-outcome contracts | `Approved`/`Pending` | Separate truth lenses, source/coverage assertions, synthetic portability proof and default-deny export control pass |
| Later phase | Phone attribution discovery, controlled incrementality and value-based optimization | `Pending later phase` | Each has its own evidence, business-truth, privacy, experiment and bidding gate |
| Governance | Marketing operations context and shared metric dictionary | `Verified`/`Partial` | Every material source, integration, metric, gap and failure-response change remains synchronized |

Eligible Track A CRM outcomes do not wait for Stape or a Supabase source
switch. Stape promotion does not inherit authorization from Track A.

## Change Control

Update this register when:

- a waiting item is completed or newly blocked;
- a platform destination is created, promoted, paused, or selected for
  optimization;
- a Stape domain, container, subscription, API key, monitoring rule, power-up,
  MCP capability, or production route changes;
- a Cloud Run, Dataform, Scheduler, Pub/Sub, Cloud Tasks, Secret Manager, or
  BigQuery production contract changes;
- a system integration, known gap, risk severity or what-if response changes;
- a parent, franchise, KinderTales, GreenRope, Mailchimp, GAConnector, or
  Synuma ownership boundary changes;
- a commercial term or delivery scope is confirmed.

Never put passwords, tokens, cookie values, raw identifiers, parent/child PII,
or private payloads in this register.

## Authoritative Detail

- [Measurement platform handover](./measurement-platform-handover-2026-07-27.md)
- [Google Cloud and Stape measurement platform blueprint](../superpowers/plans/2026-07-25-google-cloud-stape-measurement-platform-blueprint.md)
- [Parent sGTM GA4 routing status, 2026-08-04](../10-conversion-tracking/parent-sgtm-ga4-routing-status-2026-08-04.md)
- [Parent sGTM completion, 2026-08-05](../10-conversion-tracking/parent-sgtm-completion-2026-08-05.md)
- [Google Cloud and Stape capacity baseline](../20-bigquery/google-cloud-stape-capacity-baseline-2026-07-25.md)
- [Reusable data contracts and future product readiness](../20-bigquery/reusable-data-contracts-and-future-product-readiness-2026-08-06.md)
- [Dataform source control and parity](../20-bigquery/dataform-source-control-and-parity-2026-07-25.md)
- [BigQuery marketing intelligence blueprint](../superpowers/plans/2026-06-12-bq-marketing-intelligence-blueprint.md)
- [Parent CRM offline-conversion blueprint](../superpowers/plans/2026-07-23-parent-crm-offline-conversion-activation-blueprint.md)
- [Parent CRM offline-conversion implementation report](../10-conversion-tracking/parent-crm-offline-conversion-implementation-report.md)
- [Parent Form 4 and KinderTales boundary](../10-conversion-tracking/parent-form4-kindertales-attribution-boundary-2026-07-10.md)
- [Parent omnichannel vendor API request](../10-conversion-tracking/parent-omnichannel-vendor-api-request-2026-07-25.md)
- [Parent Form 4 omnichannel WordPress handoff](../10-conversion-tracking/parent-form4-omnichannel-wordpress-handoff-plan-2026-07-25.md)
- [KinderTales and GreenRope identity/webhook vendor email](../10-conversion-tracking/kindertales-greenrope-identity-webhook-email-2026-07-25.md)
- [Parent KinderTales identity WordPress rollout](../10-conversion-tracking/parent-kindertales-identity-wordpress-rollout-2026-07-25.md)
- [Parent canonical writeback observation](../10-conversion-tracking/parent-paid-writeback-production-observation-2026-07-10.md)
- [Franchise GAConnector shadow rollout](../10-conversion-tracking/franchise-gaconnector-shadow-rollout-2026-07-20.md)
- [Live WordPress tracking plugin inventory](../10-conversion-tracking/live-wordpress-tracking-plugin-inventory-2026-07-27.md)
- [Paid-media naming and copy standard](../40-naming-convention/cefa-paid-media-naming-and-copy-standard.md)
- [Full conversion-tracking assessment](../10-conversion-tracking/full-conversion-tracking-assessment-and-execution-plan-2026-07-09.md)
- [Marketing and BI alignment final decision](../70-growth-operations/marketing-bi-alignment-final-decision-and-email-2026-07-27.md)
