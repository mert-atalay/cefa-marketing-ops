# CEFA BigQuery Marketing Intelligence Blueprint

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Evolve CEFA BigQuery from reliable dashboard reporting into a governed marketing intelligence engine for school, franchise, local/AEO, creative, predictive, and approved activation use cases.

**Architecture:** School Manager and KinderTales remain the operational Parent
inquiry/admissions delivery system. GreenRope is the approved Parent lifecycle
source for the current offline-conversion project. Synuma/SiteZeus remains the
Franchise Canada and Franchise USA CRM/business-delivery system. The BI team
reports that Supabase already consolidates Parent business data from
KinderTales/GreenRope; that organizational role is accepted while its schema,
grain, identity, history, timestamps, freshness, and lineage remain pending
read-only verification. BigQuery remains the marketing intelligence,
measurement, semantic, predictive, and activation-prep warehouse. Existing
dashboard contracts in `mart_cefa_growth_dashboard` stay stable while new
sources enter as additive, QA-labeled contracts.

**Tech Stack:** BigQuery, BigQuery Data Transfer Service, Dataform, BigQuery
ML, Gemini in BigQuery, Cloud Run and Cloud Run jobs, Cloud Functions where
useful, Cloud Scheduler, Pub/Sub, Cloud Tasks, Eventarc, Workflows, Cloud
Monitoring and Logging, Secret Manager, Cloud Storage, Dataplex/metadata
governance, Vertex AI when BQ-native options are insufficient, Supabase safe
exports, Hightouch for approved reverse ETL, GA4, Google Ads, Meta, GSC, GBP,
DataForSEO, Gravity Forms, and CRM lifecycle facts.

**Status:** Locked roadmap as of 2026-06-12. Future BQ, marketing intelligence, prediction, semantic layer, Hightouch, and Supabase bridge work should use this as the strategic roadmap unless Mert explicitly approves a replacement.

**Approved implementation addendum, 2026-07-23:** CEFA approved further
development of the existing BigQuery/Dataform/Cloud Run/Scheduler/Secret
Manager foundation and Stape Business as the managed sGTM layer. The
cross-workstream status, commercial references, ownership boundaries,
acceptance gates, and parallel build board are registered in
[CEFA Measurement And Activation Program Register](../../00-governance/measurement-and-activation-program-register-2026-07-23.md).
This is an extension of the roadmap, not permission to create a second
warehouse, replace current conversions without parity, or place KinderTales or
Synuma delivery behind sGTM.

**Capacity addendum, 2026-07-24:** CEFA confirmed that the Stape Business plan
is available and that this roadmap may use the full relevant Google Cloud and
BigQuery capability set. Implementation is not restricted to free tiers and a
new cloud workload does not need cost-only approval when it serves an approved
roadmap outcome. Billing visibility remains informational; data quality,
security, privacy, identity, platform eligibility, QA, and rollback controls
remain mandatory. See the program register for the operational decision.

**Definitive implementation blueprint, 2026-07-25:** The coordinated Google
Cloud, BigQuery, Dataform, Stape sGTM, offline-activation, visibility, and
targeting implementation is specified in
[CEFA Google Cloud And Stape Measurement Platform Blueprint](./2026-07-25-google-cloud-stape-measurement-platform-blueprint.md).
This document remains the locked strategic roadmap; the newer blueprint owns
implementation architecture, sequencing, acceptance, and definition of done.

**Marketing/BI alignment addendum, 2026-07-27:** CEFA approved the
Supabase/BigQuery boundary, two parallel implementation tracks, independent
CRM and Stape promotion gates, consent-capable Stape plumbing with CMP
procurement deferred, and later gated phone-attribution, incrementality, and
value-based work. The current guarded GreenRope CRM path may activate after
its own identity, eligibility, baseline, deduplication, platform-validation,
diagnostic, and kill-switch gates; it does not wait for Stape or a Supabase
source switch. Supabase can replace that source only after a versioned
contract, proof-of-concept record, parity, one-sender control, accepted-ID
reconciliation, and rollback pass. See the
[final alignment decision](../../70-growth-operations/marketing-bi-alignment-final-decision-and-email-2026-07-27.md).

**Reusable-contract addendum, 2026-08-06:** CEFA will make the warehouse
architecture portable through versioned measurement, conversation, capacity,
action-to-outcome, model, and interface contracts while keeping the CEFA data
plane CEFA-only. Any future external runtime must be separately owned,
deployed, credentialed, billed, and populated; CEFA row-level data and private
runtime do not become product assets by default. The detailed extension is
[CEFA Reusable Data Contracts And Future Product Readiness](../../20-bigquery/reusable-data-contracts-and-future-product-readiness-2026-08-06.md).

---

## Final Position

Use the new 2027 blueprint as direction, but do not rebuild the warehouse from scratch.

The right CEFA path is:

- preserve existing dashboard-safe objects and scheduled refreshes
- add the missing event, source, lifecycle, and semantic layers around them
- migrate orchestration toward Dataform gradually
- expose only certified contracts to dashboards, Supabase, Hightouch, and AI agents
- never copy raw parent/child PII into BigQuery semantic marts
- never let predictive or activation outputs change campaigns, budgets, CRM records, review replies, or public content without approval

The phrase "dual truth" should be used carefully. CEFA should not have two
conflicting truths for the same metric. The split is:

- School Manager/KinderTales owns operational Parent inquiry and admissions
  delivery truth;
- GreenRope owns the approved Parent CRM lifecycle evidence used by the
  offline-conversion project;
- Synuma/SiteZeus owns Franchise operational CRM/business-delivery truth;
- BigQuery owns marketing measurement and intelligence truth;
- approved safe lifecycle facts connect these systems without making
  Supabase, Stape, or BigQuery the operational CRM.
- Supabase is the reported consolidated Parent business-data layer; BigQuery
  receives only the minimum verified record-level outcomes and returns
  certified marketing summaries under a shared metric dictionary.

## What I Accept From The New Blueprint

- Form 4 should get a durable `event_id` before submission.
- Attribution fields, school context, click IDs, and source evidence should be captured first-party and sent to BigQuery.
- The existing Gravity Forms and KinderTales delivery path should remain untouched in the first pass.
- A Cloud Run collector is a good fit for webhook, browser-event audit, and future CAPI backup.
- Supabase should expose an `analytics_export` safe schema instead of giving BigQuery raw CRM tables.
- BigQuery should return clean scores, source context, and summaries back to Supabase, not raw marketing logs.
- Dataform should become the long-term transformation and testing layer.
- BigQuery ML/Gemini/Vertex should come after the facts and quality gates are stable.
- Hightouch should read approved BQ contracts only and act through approval gates.

## What I Would Modify

- Do not immediately create every proposed `cefa_*` dataset as a parallel warehouse. Map the concepts into current datasets first, then create new datasets only when isolation is useful.
- Do not move existing dashboard readers or Supabase syncs until replacements are reconciled and explicitly promoted.
- Do not start with full server-side GTM. Start with Form 4 event parity: browser event, webhook event, BQ event, GA4 generate_lead, and Meta CAPI backup.
- Do not treat Meta or Google platform conversions as final business CPL. Business CPL should use trusted spend divided by deduped, non-test, paid Form 4 or CRM-safe target leads.
- Do not run MMM until weekly source/lifecycle history is stable and annotated with business events.

## Phase 0 - Protect Current Truth

**Outcome:** Existing dashboard metrics remain stable while richer BQ work continues safely.

- [ ] Keep `mart_cefa_growth_dashboard` contracts unchanged unless a promotion is approved.
- [ ] Keep `dashboard_bq_monitor_latest`, Cloud Run safety monitor, and Codex control check active.
- [ ] Before every warehouse release, snapshot current school paid, franchise paid, CRM/forms, GA4, and QA totals.
- [ ] After every release, compare spend, leads, CPL, row counts, freshness, and dashboard-safe status.
- [ ] Document any dashboard-facing change before the dashboard agent consumes it.

## Phase 1 - Governance, Registry, And Metric Definitions

**Outcome:** Every table says what it is, whether it is safe, and what limitations it has.

- [x] Expand the contract registry for dashboard, intelligence, predictive, activation, and blocked/candidate contracts.
- [ ] Add or standardize fields: `data_through_date`, `last_loaded_at`, `source_systems`, `source_status`, `qa_status`, `dashboard_safe`, `predictive_safe`, `reconciliation_status`, `known_limitations`, `serving_contract_version`.
- [x] Create or formalize the metric registry for business CPL, paid leads, qualified leads, tours, enrollments, source quality, capacity opportunity, attribution confidence, creative fatigue, and AI visibility.
- [ ] Add Cloud Monitoring alerts for stale source dates, failed Cloud Run
  jobs, failed QA, quota pressure, abnormal usage, and unexpected volume.
- [ ] Keep Hightouch, Supabase, Vercel, and AI readers restricted to approved contracts.

Progress note, 2026-06-12: Day 0 governance/source dictionary implemented in
`marketing-api-488017.cefa_governance` and reflected in the
[governance data taxonomy](../../00-governance/data-taxonomy.md). The remaining
Phase 1 work is field standardization on source contracts, monitoring alerts,
and consumer access enforcement.

## Phase 2 - Form 4 First-Party Event Foundation

**Outcome:** Parent inquiry tracking becomes event-based, deduped, and platform-reconcilable without changing the parent-facing submission flow.

- [x] Add `event_id` generation before Form 4 submit.
- [x] Capture hidden fields for UTM values, click IDs, landing URL, referrer, landing school slug, selected school slug, campaign target school slug, and consent state.
- [ ] Send Form 4 webhook to a Cloud Run collector while preserving the existing KinderTales delivery path.
- [ ] Write raw and normalized no-PII event audit rows to BigQuery.
- [ ] Add reconciliation tables for browser event, webhook event, GA4 generate_lead, Meta Pixel, and future Meta CAPI.
- [x] Preserve cross-school inquiry flags instead of hiding them.

Progress note, 2026-07-23: parent canonical attribution writeback is live,
Form `4` event identity is available, and the restricted offline-activation
identity capture/binder is deployed. School Manager and KinderTales remain
unchanged. GreenRope still requires the two exact opportunity identity fields
and a controlled read-back before CRM-stage dispatch.

## Phase 2B - Managed Server-Side Tagging

**Outcome:** Stape Business strengthens first-party website collection and
server delivery without creating duplicate conversions or replacing CRM
business truth.

- [ ] Provision Stape Business under CEFA administrative and billing
  ownership.
- [ ] Inventory current web GTM, GA4, Google Ads, Meta, event IDs, custom
  scripts, consent inputs, and hostname/destination boundaries.
- [ ] Carry consent/eligibility state through the event envelope and
  destination rules. Keep user-data matching, Customer Match, audiences, and
  other consent-dependent features disabled until separately approved.
- [ ] Design first-party endpoints and strict Parent, Franchise Canada, and
  Franchise USA routing isolation.
- [ ] Keep browser interaction capture and route approved events through sGTM
  in shadow before destination promotion.
- [ ] Preserve neutral event names and use the same `cefa_event_id` for
  browser/server deduplication.
- [ ] Prove GA4 parity, Google once-only conversion receipt, Meta Pixel/CAPI
  deduplication, and no KinderTales or Synuma regression.
- [ ] Enable Business power-ups only when an approved requirement and QA
  record exist.
- [ ] Export container configuration, access inventory, monitoring,
  request-capacity alerts, and rollback runbook before production promotion.

## Phase 3 - Native Source Gap Closure

**Outcome:** BQ stops relying only on inferred GBP/SEO/local evidence and starts ingesting direct source facts.

- [ ] Add native Google Business Profile performance by location/day: profile interactions, calls, direction requests, website clicks, searches, and school mapping.
- [ ] Add Google Search Console query/page/device/country daily facts for parent and franchise domains.
- [ ] Add DataForSEO rank, SERP, AI visibility, and technical SEO snapshots where useful and cost-safe.
- [ ] Add Google Ads native transfer coverage for campaign, ad group, keyword/search term, asset, and budget diagnostics where available.
- [ ] Continue Meta through the most reliable API/Supermetrics path, with campaign-level truth protected before creative/ad-set promotion.
- [ ] Add optional review/reputation ingestion only with human-approved review response workflow.

## Phase 4 - Supabase Safe Lifecycle Bridge

**Outcome:** BigQuery can measure lead quality, tours, enrollments, and capacity without becoming the CRM.

- [ ] Verify the reported BI-owned KinderTales/GreenRope-to-Supabase pipeline
  read-only before treating it as a production marketing source.
- [ ] Ask Supabase to expose safe `analytics_export` views for lifecycle events, stage snapshots, household identity tokens, capacity snapshots, consent status, and admissions activity.
- [ ] Ingest only safe lifecycle fields into BigQuery: lead ID, household ID, event ID, school UUID, stage, stage date, tour flags, enrollment flag, lost reason category, speed-to-lead bucket, consent state.
- [ ] Do not ingest parent names, child names, raw emails, raw phones, child DOB, street address, free-text CRM notes, or sensitive admissions comments.
- [ ] Build no-PII lifecycle facts that join to Form 4 and paid source evidence by `event_id`, `lead_id`, `household_id`, and `school_uuid`.
- [ ] Add capacity snapshots by school/month and mark unknown capacity as partial, not zero.
- [ ] Preserve the existing direct GreenRope path for guarded activation,
  parity, diagnosis, or bounded fallback until a versioned Supabase contract
  reconciles and one production sender is explicitly promoted.
- [ ] Require a proof-of-concept record, direct/Supabase parity, baseline
  protection, accepted-ID reconciliation, and named rollback owner before a
  source-authority switch.

## Phase 5 - Core Facts And Semantic Marts

**Outcome:** Dashboards and analysts use stable business facts, not raw joins.

- [ ] Formalize canonical school identity: `school_uuid`, canonical slug, aliases, region, province, status, GBP place ID, website URL, inquiry URL, and reporting scope.
- [ ] Formalize campaign identity: platform, account, campaign ID/name, target school slug, lead type, objective, UTM campaign, status, and mapping confidence.
- [ ] Build or certify core facts for parent leads, touchpoints, CRM lifecycle events, campaign spend, creative performance, and capacity.
- [ ] Promote dashboard-safe marts only after reconciliation passes.
- [ ] Keep Supabase delivery tables small and final: school/day/campaign totals, source context, lead scores, message context, and approved recommendations.

## Phase 6 - Paid Media And Creative Reconciliation

**Outcome:** School drilldowns can explain performance by campaign, ad group, keyword, ad set, creative, and audience without distorting totals.

- [ ] Certify Google ad group totals against trusted campaign/school totals.
- [ ] Keep Google keyword/search term as engagement/search insight unless keyword-level conversion truth exists.
- [ ] Reconcile Meta ad set and creative spend/leads to trusted campaign totals before allowing CPL or spend ranking.
- [ ] Store creative metadata and URLs only; no creative binaries in BigQuery.
- [ ] Add Cloud Storage asset manifest, Cloud Vision OCR/labels, and Gemini theme labels after creative metadata QA passes.
- [ ] Build creative learning marts for fatigue, message themes, CTA, format, school context, and next-test recommendations.

## Phase 7 - Local, AEO, Reputation, And SEO Intelligence

**Outcome:** CEFA can understand local visibility and AI/search demand at the school level.

- [ ] Build semantic marts for GSC query/page opportunities.
- [ ] Build GBP/local performance scorecards by school.
- [ ] Build local reputation scorecards from reviews and response SLA, with human approval for any response workflow.
- [ ] Add AEO/AI visibility facts from DataForSEO/manual prompt tests where source access is stable.
- [ ] Convert these into school page, schema, content, and local listing opportunity backlogs.

## Phase 8 - Predictive Analytics V1

**Outcome:** BQ highlights what needs attention next, while recommendations remain advisory.

- [ ] Start with heuristic models already compatible with current BQ history.
- [ ] Add BigQuery ML models only when labels and history are strong enough: lead-to-tour propensity, enrollment propensity, no-show risk, school demand forecast, creative fatigue, anomaly detection.
- [ ] Store model metadata: model version, training window, features, confidence, limitations, scored date, expiry date.
- [ ] Compare predictions to actuals and track error before promotion.
- [ ] Push scores to Supabase only after business review and with expiry dates.

## Phase 9 - Dataform And Production Data Engineering

**Outcome:** Transformations become easier to test, debug, document, and release.

- [ ] Inventory current Cloud Run SQL scripts by source, staging, core, semantic, predictive, activation, and governance role.
- [ ] Move stable SQL transformations into Dataform incrementally, beginning with governance/source registry and semantic marts.
- [ ] Keep Cloud Run for source extraction, custom API calls, and backward-compatible refresh entrypoints.
- [ ] Add Dataform assertions for freshness, uniqueness, row count, spend reconciliation, lead reconciliation, and null safety.
- [ ] Add Dataplex/Knowledge Catalog descriptions after stable contracts are defined.

Progress note, 2026-07-23: an additive Dataform QA foundation exists, while
Cloud Run remains the production orchestrator. The approved Google Cloud
development scope must reuse `marketing-api-488017`, keep API extraction and
activation in Cloud Run, migrate only stable SQL, and supply Git-linked
releases, assertions, monitoring, least-privilege IAM, quota/capacity
visibility, and rollback documentation. Free-tier limits and cost-only
approval are not promotion gates.

## Phase 10 - MMM And Incrementality Readiness

**Outcome:** Annual and quarterly budget planning becomes evidence-based rather than platform-report based.

- [ ] Build weekly MMM readiness table with spend, impressions, clicks, paid leads, qualified leads, tours, enrollments, capacity, seasonality, holidays, school openings, GBP actions, and organic clicks.
- [ ] Annotate major launches, tracking changes, creative refreshes, pauses, and website changes.
- [ ] Design controlled matched-market or pre/post tests with capacity,
  seasonality, pre-period, minimum-sample, budget-approval, and stopping rules
  before relying on model outputs.
- [ ] Use Meridian or another MMM path only after enough stable weekly history exists.
- [ ] Quantify phone-originated inquiry, tour, and enrollment coverage from
  existing evidence before considering a controlled dynamic-number-insertion
  pilot. No vendor or universal percentage trigger is pre-approved.

## Phase 11 - Controlled Activation

**Outcome:** Insights become action queues, not autonomous changes.

- [ ] Create recommendation queue with owner, source evidence, confidence, approval status, approved by, implemented at, and outcome tracking.
- [ ] Use Hightouch only on approved BigQuery contracts and its own audit/planner schemas.
- [ ] Start with Supabase reporting/score outputs before ad-platform activation.
- [ ] Add offline conversion, suppression, seed audience, and CAPI enrichment tables only after privacy and QA review.
- [ ] Keep CRM-stage actions count-only and secondary. Add value only from
  Supabase/KinderTales-verified final enrollment truth and an approved
  economics model after reconciliation, deduplication, volume, and bidding
  gates pass; never value GreenRope `crm_closed_won` as final enrollment.
- [ ] No automatic campaign, budget, bid, CRM, review, content, or public-site changes.

## Phase 12 - Agent-Safe Semantic Layer

**Outcome:** CEFA can ask natural-language questions over trusted marketing data safely.

- [ ] Create agent-safe views for school growth, campaign reconciliation, lead ops bottlenecks, creative learning, AEO opportunities, and local reputation.
- [ ] Ensure agent views expose definitions, freshness, QA state, and source contracts.
- [ ] Block raw table access for agents.
- [ ] Log agent runs, data scopes used, recommendations, approval status, and executed action if any.
- [ ] Require source citations and freshness timestamps in any executive summary or recommendation.

## Phase 13 - Reusable Contracts And Future Product Readiness

**Outcome:** CEFA's proven architecture can inform a future separately hosted
product without turning the CEFA warehouse into an external product data
plane.

- [ ] Build separate facts for deduplicated business outcomes, CEFA
  attribution, and platform-reported/accepted/matched observations; never sum
  cross-platform conversion credit as unique business outcomes.
- [ ] Add product-grade metric eligibility fields for identity, attribution,
  spend, outcome, freshness, QA, sample, confidence, and known limitations.
- [ ] Add a provider-neutral structured conversation contract for chatbot,
  email, and later approved channels, with raw text restricted and
  time-bounded.
- [ ] Add a source-confirmed aggregate capacity/availability contract that
  distinguishes licensed, staffed, enrolled, waitlisted, sellable, and
  unknown states.
- [ ] Extend the recommendation queue into an action-to-outcome ledger that
  proves approval, execution, evaluation window, observed result, and
  postmortem.
- [ ] Version feature sets, labels, models, baselines, calibration, drift,
  confidence, expiry, and approved/prohibited uses.
- [ ] Keep provider adapters separate from canonical contracts and prove
  portability in a separate empty environment using synthetic fixtures.
- [ ] Default external benchmarking and exports to disabled; require legal,
  privacy, cohort, comparability, audit, and revocation gates before any
  aggregate release.
- [ ] Keep any future product repository, cloud project, service identities,
  secrets, runtime, datasets, destinations, billing, and customer data plane
  separate from CEFA.

Implementation detail and acceptance criteria are governed by the
[reusable-contract extension](../../20-bigquery/reusable-data-contracts-and-future-product-readiness-2026-08-06.md).

## Immediate Parallel Priorities

1. Continuously protect KinderTales, Synuma, website conversion, dashboard,
   and existing campaign contracts.
2. **Track A:** complete GreenRope identity fields, the controlled Parent
   read-back, per-record eligibility, and guarded CRM outcome activation.
3. **Track A:** inspect Supabase, approve the minimum outcome contract and
   shared metric dictionary, then reconcile before any source switch.
4. **Track B:** verify Stape ownership/access and build Parent in shadow with
   exact event-ID deduplication and consent-state gating.
5. **Track B:** promote one property at a time only after its independent
   parity, destination-isolation, business-delivery, and rollback gates pass.
6. **Shared spine:** productionize Dataform, Cloud monitoring, queues,
   dead-letter handling, runbooks, and private runtime source.
7. Add native GBP/GSC, certified paid detail, capacity-aware school marts, and
   predictive models after their source contracts pass.
8. Add Hightouch, audiences, phone attribution, incrementality, and
   value-based optimization only behind their separate evidence and approval
   gates.
9. Version the truth-lens, conversation, capacity, action-to-outcome, and
   portable-interface contracts before treating the architecture as reusable
   outside CEFA.

## Dashboard Agent Handoff

No current dashboard metrics should change from this plan by default.

The dashboard agent can safely continue consuming current `mart_cefa_growth_dashboard` contracts. New views should be consumed only when they are explicitly marked `dashboard_safe = true`, have passing QA, and have a handoff note that names the changed contract and expected UI behavior.

## Capacity, Reliability, And Safety Controls

- Register approved vendor/license costs and renewal terms in the measurement
  program register for operational visibility, not as an implementation gate.
- The Stape Business license and any separate sGTM implementation charge
  should still be reconciled for clean ownership and renewal records.
- Do not constrain approved work to Google Cloud or BigQuery free tiers.
- Choose event grain, refresh frequency, storage, compute, and managed services
  from the business SLA, data quality requirement, and technical fit.
- Keep raw event retention, partitioning, clustering, lineage, and deletion
  rules explicit before high-volume sources are added.
- Monitor BigQuery and Google Cloud usage for quota pressure, abnormal growth,
  failed delivery, and architecture regressions. Monitoring is informational
  unless reliability, security, or data quality is at risk.
- Add Cloud Vision, Gemini, Vertex AI, and MMM workloads after source tables
  and use-case acceptance criteria are stable; expected monthly cost is not a
  separate prerequisite.
- Keep all write-capable actions behind human approval.

## Non-Goals

- Do not replace Supabase as CRM.
- Do not copy raw parent/child PII into BigQuery.
- Do not replace Form 4 in the first pass.
- Do not break KinderTales delivery.
- Do not use platform conversions as final business CPL.
- Do not merge parent enrollment, open house, summer camp, franchise, and other lead types into one CPL bucket.
- Do not launch autonomous budget, CRM, creative, review, or publishing agents;
- Do not use the CEFA warehouse, row-level data, credentials, platform
  destinations, or private runtime as a future external product data plane.
- Do not publish cross-organization benchmarks without explicit legal,
  privacy, comparability, minimum-cohort, audit, and revocation gates.
