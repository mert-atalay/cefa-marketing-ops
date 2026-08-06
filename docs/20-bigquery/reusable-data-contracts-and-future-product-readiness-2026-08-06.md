# CEFA Reusable Data Contracts And Future Product Readiness

**Decision date:** 2026-08-06  
**Owner:** CEFA marketing measurement  
**Status:** Approved roadmap extension; implementation pending  
**Strategic anchor:**
[CEFA BigQuery Marketing Intelligence Blueprint](../superpowers/plans/2026-06-12-bq-marketing-intelligence-blueprint.md)  
**Implementation anchor:**
[CEFA Google Cloud And Stape Measurement Platform Blueprint](../superpowers/plans/2026-07-25-google-cloud-stape-measurement-platform-blueprint.md)

## Purpose

This extension makes the CEFA marketing-data foundation reusable for future
products without turning CEFA's warehouse into an external product database.
It adds the missing contracts needed for stronger conversation intelligence,
capacity-aware decisions, trustworthy measurement, learning from completed
actions, and later deployment into a separate product environment.

This document does not authorize an external product launch, CEFA data
sharing, benchmark publication, autonomous marketing changes, or a second
production runtime inside the public repository.

## Locked Architecture Decision

1. CEFA BigQuery remains CEFA's marketing measurement, intelligence, and
   activation layer.
2. Supabase and the approved operational systems remain the business-data
   layer; BigQuery continues to receive only the minimum verified outcomes and
   safe aggregate context it needs.
3. Reusable schemas, tests, adapters, and decision logic should be designed as
   versioned contracts rather than CEFA-specific one-off queries.
4. Any future external product must use a separate private repository, Google
   Cloud project and billing boundary, service identities, secrets, datasets,
   Stape/GTM destinations, runtime, monitoring, and customer data plane.
5. A future product may reuse legally approved schema and code patterns. It
   must not reuse CEFA row-level data, credentials, platform tokens, customer
   identities, private runtime artifacts, or an unrestricted CEFA benchmark.
6. Detailed commercial product strategy, pricing, customer research, and
   private implementation material remain outside this public repository.

The practical rule is: **reuse the architecture, never the CEFA data plane.**

## Foundation Already Covered

The current roadmap already provides:

- stable event, form, inquiry, adult, household, dependent, opportunity,
  school, campaign, and platform identity boundaries;
- first-party web collection and browser/server deduplication;
- source-faithful landing, restricted identity, canonical facts, semantic
  marts, activation ledgers, and certified serving contracts;
- no-PII normal marts and bounded restricted identity processing;
- business outcomes kept separate from platform-reported conversions;
- lifecycle, email, local search, creative, predictive, MMM, audience, and
  agent-safe roadmap phases;
- human approval, diagnostics, idempotency, rollback, and source-confidence
  gates.

These foundations should be extended, not duplicated.

## Required Additions

### 1. Three Measurement Truth Lenses

Do not collapse business results, CEFA attribution, and platform reporting
into one conversion column. Build separate canonical facts and a certified
comparison view:

| Lens | Meaning | Primary use |
|---|---|---|
| Business outcome | Deduplicated inquiry or downstream outcome confirmed by the approved operational source | Business performance and denominator truth |
| CEFA attribution | CEFA's deterministic or approved modeled assignment of business outcomes to marketing touchpoints | Cross-channel decision support |
| Platform observation | Conversion reported, accepted, matched, or modeled by Google, Meta, GA4, or another platform | Delivery diagnostics and platform optimization context |

The certified comparison contract must expose, where applicable:

- `business_outcome_count`;
- `internal_attributed_outcome_count`;
- `platform_reported_conversion_count`;
- `platform_accepted_conversion_count`;
- `platform_matched_conversion_count` when the platform exposes it;
- `identity_coverage_rate`;
- `paid_source_coverage_rate`;
- `outcome_coverage_rate`;
- `attribution_confidence` and `attribution_method`;
- `data_through_at`, source freshness, QA state, calculation version, and
  known limitations.

Platform credits from different platforms must never be summed and labelled
as unique business outcomes. Internal attributed credit may equal one per
business outcome only under a documented attribution model and grain.

### 2. Structured Conversation Intelligence

Add a provider-neutral contract for chatbot, web chat, future call summaries,
email replies, and other approved conversational sources. The canonical
contract should support:

- source, channel, `conversation_id`, `message_id`, direction, and event time;
- anonymous/session identity plus inquiry, adult, household, and school keys
  only when deterministically linked;
- intent, topic, age band, program interest, desired start window, school or
  market interest, objection, and urgency;
- answer source/provenance, retrieval confidence, unanswered-question flag,
  resolution, escalation, and next action;
- inquiry or lifecycle outcome link when exact identity exists;
- eligibility, consent state, taxonomy version, classifier/model version,
  confidence, and expiry.

Raw transcripts do not belong in normal marketing marts. If CEFA has a valid
reason to retain them, they require restricted storage, explicit retention,
access control, redaction, and approval. Normal marts should hold approved
structured labels, evidence references, and aggregate counts.

This contract lets CEFA improve chatbot answers, content/AEO priorities,
school demand understanding, intake quality, and creative messaging without
making free text the reporting key.

### 3. Capacity And Availability Guardrail

Add a source-confirmed, aggregate capacity snapshot contract with:

- `school_uuid`, snapshot time, program and/or age band;
- licensed capacity, staffed capacity, active enrollment, waitlist count, and
  sellable openings when each value is actually available;
- desired start-window compatibility where the source supports it;
- source system, source record/version, freshness, QA state, confidence, and
  known limitations.

Unknown capacity is `unknown`, never zero. Licensed capacity is not the same
as staffed or sellable capacity. Capacity first acts as a reporting and
recommendation guardrail; it must not automatically suppress or increase
spend until source quality, operating ownership, and decision rules pass.

### 4. Action-To-Outcome Learning Ledger

Extend the existing recommendation queue into a durable learning contract:

- recommendation and experiment ID;
- target school, market, campaign, content, audience, or other governed
  entity;
- evidence, hypothesis, recommended action, constraints, confidence, logic
  or model version, and expiry;
- owner, approval state, approver, execution state, executed time, and exact
  platform/content object IDs;
- baseline and evaluation windows, expected outcome, observed outcome,
  incremental estimate where valid, result confidence, and postmortem;
- rollback or stop action and final disposition.

This is what allows the system to learn which recommendations worked. A
recommendation is not training evidence until execution and outcome are both
confirmed.

### 5. Product-Grade Metric Eligibility

Every promoted KPI, recommendation, model feature set, or comparison must
declare:

- source and source status;
- business definition and grain;
- data-through time and freshness SLA;
- spend completeness and outcome completeness;
- identity and attribution coverage;
- minimum sample or cohort rule;
- QA/reconciliation status;
- confidence, known limitations, and allowed uses.

Do not label a metric `true CAC`, `incremental lift`, or a complete customer
journey when spend, outcomes, identity, or source coverage is partial. Use
qualified labels such as `paid media cost per verified inquiry` until the
stronger contract is earned.

### 6. Model And Feature Readiness

Keep deterministic diagnostics first. A promoted feature set or model must
record:

- feature-set and label-definition versions;
- training, validation, scoring, and business-observation windows;
- source coverage and data-through date;
- model/logic version, baseline, calibration, confidence, and expiry;
- drift and error results;
- approved use, prohibited use, owner, and rollback.

No model becomes an optimization signal merely because it performs well in a
warehouse evaluation. Platform volume, timeliness, match quality, experiment
design, and explicit approval remain separate gates.

### 7. Portable Interface Contract

Provider-specific adapters should map into stable canonical contracts rather
than leak provider field names into every mart. New portable interfaces should
include:

- `contract_version`, `source_system`, source object ID, observed time,
  ingested time, and correction/version evidence;
- canonical organization/property, market, school, campaign, event, and
  outcome keys where relevant;
- eligibility, quality, freshness, and limitation fields;
- idempotent natural or HMAC transaction identity;
- schema tests and synthetic fixtures.

Do not retrofit a tenant key into every CEFA table only for appearance. A
logical organization/tenant boundary belongs in portable interfaces and in a
future separate product environment when there is a real second tenant.

### 8. Platform Delivery Contract

Keep transport responsibilities explicit:

- website events use the approved first-party sGTM destination routes;
- new Google offline CRM events should use the Google Data Manager API where
  eligible, with `validateOnly`, stable transaction IDs, request IDs,
  diagnostics, age checks, and accepted-ID reconciliation;
- the Google Ads API remains appropriate for conversion-action settings,
  goal/campaign read-back, supported adjustments, and guarded campaign
  operations;
- Meta lifecycle events use Conversions API with stable `event_id`, genuine
  match evidence, Test Events, diagnostics, and reporting-only custom
  conversions until optimization is separately approved;
- no dispatcher sends another copy of the existing website inquiry event.

### 9. Benchmark And External Export Firewall

Cross-organization benchmarks are disabled by default. They may be considered
only after legal/privacy review confirms rights and the implementation has:

- aggregate-only outputs;
- a formally approved minimum cohort rule;
- no family, school, franchise candidate, employee, campaign secret, or
  customer-level re-identification path;
- no single organization dominating a benchmark cohort;
- documented metric comparability, source coverage, and confidence;
- export review, access logs, revocation, and deletion controls.

CEFA row-level data is not a default training set, demo dataset, benchmark
pool, or customer seed. Synthetic fixtures are the default for portability
tests.

## Roadmap Placement

| Existing phase | Addition | Exit evidence |
|---|---|---|
| Governance and metric definitions | Three truth lenses and metric-eligibility fields | One certified comparison reconciles business, internal attribution, and platform observations without double counting |
| Native source and omnichannel phases | Structured conversation adapter and safe aggregate marts | Provider totals reconcile; raw text stays restricted; labels expose provenance and confidence |
| Supabase lifecycle and core facts | Capacity/availability snapshot | School UUID, age/program grain, freshness and unknown-state assertions pass |
| Predictive intelligence | Feature/model registry and evaluation contract | Baseline, calibration, drift, expiry and allowed-use fields pass |
| Controlled activation | Action-to-outcome learning ledger | One approved action traces from evidence through execution and measured result |
| Agent-safe semantic layer | Product-grade eligibility and citation fields | Agent output states source, freshness, confidence and limitation |
| Future portability gate | Separate empty-environment deployment with synthetic data | No CEFA rows, credentials, destinations or private runtime cross the boundary |

## Implementation Sequence

1. Version and implement the measurement truth-lens contract first because it
   prevents misleading reporting across every later feature.
2. Add structured conversation and capacity adapters as additive sources;
   keep both out of current certified dashboards until reconciliation passes.
3. Extend the recommendation queue into the action-to-outcome ledger before
   using recommendations as learning evidence.
4. Add feature/model metadata and product-grade eligibility to predictive and
   agent-safe views.
5. Prove the canonical schemas in a separate empty environment using only
   synthetic fixtures before claiming portability.
6. Consider external benchmarking only through a later legal, privacy,
   commercial, and technical approval gate.

## Acceptance Gates

- Current CEFA dashboards, forms, KinderTales, Synuma, conversions, and
  campaign optimization remain unchanged during contract development.
- Each contract has an owner, version, grain, source, freshness, QA state,
  allowed use, retention, and rollback.
- Business outcomes, internal attribution, and platform observations remain
  separate and reconcilable.
- Conversation marts contain no unapproved raw transcript or contact data.
- Capacity `unknown` values cannot silently become zero.
- Recommendations cannot be counted as successful without confirmed
  execution and outcome evidence.
- Portable schemas deploy against synthetic data in a separate empty project.
- CEFA row-level data, credentials, platform destinations, and private runtime
  remain inside CEFA-controlled boundaries.
- External benchmarks and autonomous actions remain disabled until separately
  approved.

## Planned Versioned Artifacts

Implementation should create and register, rather than improvise, these safe
contracts:

- measurement truth-lens schema and reconciliation assertions;
- conversation-intelligence schema, taxonomy, restricted-text policy, and
  provider adapters;
- capacity/availability snapshot schema and freshness assertions;
- action-to-outcome ledger schema and evaluation rules;
- feature/model registry and promotion criteria;
- portable interface envelope and synthetic fixtures;
- external-export and benchmark policy with a default-deny control.

Until those artifacts pass their gates, this document is roadmap authority,
not evidence that the corresponding production capability exists.
