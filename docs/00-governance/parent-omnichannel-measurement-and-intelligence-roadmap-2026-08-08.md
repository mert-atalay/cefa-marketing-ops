# CEFA Parent Omnichannel Measurement And Intelligence Roadmap

**Roadmap date:** 2026-08-08  
**Owner:** CEFA marketing measurement and intelligence  
**Status:** Canonical Parent execution roadmap  
**Scope:** Parent `cefa.ca`, BigQuery/Google Cloud, Stape sGTM, CRM outcome
activation, reporting, creative intelligence, forecasting, lead scoring, MMM,
and controlled audience use

## Authority

This is the current execution roadmap for the Parent measurement and
intelligence program. It does not replace:

- the [locked long-term BigQuery strategy](../superpowers/plans/2026-06-12-bq-marketing-intelligence-blueprint.md);
- the [Google Cloud and Stape implementation architecture](../superpowers/plans/2026-07-25-google-cloud-stape-measurement-platform-blueprint.md);
- the [program register](./measurement-and-activation-program-register-2026-07-23.md),
  which owns cross-workstream status and dependencies.

Use this file to answer what remains for Parent now, in what order, and what
must be true before reporting, modeling, or activation is promoted.
Franchise Canada and Franchise USA remain isolated. Their Stape work may stay
later and must not delay Parent data correctness or intelligence work.

## Executive Answer

The Parent transport foundation is substantially complete:

- one saved Form 4 inquiry remains the business event;
- the same Form 4 event ID reaches browser and server destinations;
- GA4, Meta CAPI, Google Conversion Linker, and Google Ads Inquiry Submit run
  through the first-party Parent sGTM route;
- School Manager and KinderTales delivery remain unchanged;
- BigQuery, restricted activation tables, Cloud Run jobs, candidate serving
  views, and platform CRM-stage destinations exist.

The remaining program is no longer mainly a tagging build. It is now:

1. correct and certify paid-source classification;
2. enforce freshness, reconciliation, lineage, and production release control;
3. join exact business outcomes from Supabase/GreenRope/KinderTales;
4. activate secondary offline outcomes without duplicates;
5. upgrade existing heuristic analytics into tested, trained, governed models;
6. add creative, capacity, budget, email, and experiment evidence;
7. use trusted outcomes for reporting, audiences, and later optimization.

## Current State

| Capability | State on 2026-08-08 | What remains |
|---|---|---|
| Parent Form 4 identity | `Verified` | Continue uniqueness and saved-entry reconciliation monitoring |
| Parent browser and sGTM conversion route | `Production complete / active guarded` | Operational destination diagnostics, duplicate monitoring, recovery ownership |
| KinderTales business delivery | `Unchanged` | Monitor independently from marketing transport |
| Parent first-party attribution | `Live` | Correct the downstream paid-classification contract described below |
| Parent certified total and school counts | `Usable candidate` | Keep additive until source-classification v2 and freshness gates pass |
| BigQuery/Cloud foundation | `Substantial` | Private reproducible source, Dataform production lifecycle, alerts, replay, lineage |
| Parent CRM offline infrastructure | `Built, sending disabled` | Exact business identity, controlled live record, eligibility, production activation |
| Supabase business-outcome interface | `Contract ready, source unverified` | Read-only schema inspection, exact IDs, timestamps, history, proof record |
| GreenRope identity | `External dependency` | `cefa_event_id`, `cefa_form_entry_id`, transition evidence |
| Predictive and creative surfaces | `Heuristic candidates` | Labeled outcomes, backtests, trained models, promotion criteria |
| Meridian MMM | `Readiness only` | Longer stable history, outcomes, controls, capacity, experiments, fitted model |

## Concrete Findings Behind This Roadmap

### 1. Parent sGTM is not a shadow route

Parent web GTM version `15` and server GTM version `13` are production live
behind `edge.cefa.ca`. The controlled 2026-08-05 Form 4 test proved one saved
entry and the same event ID across the signed collector, GA4, Meta CAPI, and
Google Ads server route. The overlapping Parent legacy Meta Gateway route was
excluded while the Franchise USA dataset remained connected.

This phase now needs operational monitoring, not a second implementation.

### 2. Paid-source classification has a material defect

A read-only comparison on 2026-08-08 found:

- `439` non-test Parent rows in BigQuery for August 1-7;
- `242` were labelled Google paid, but `180` of those rows were explicitly
  `google / organic` and had no Google click ID;
- only `62` of those Google-labelled rows carried a paid medium, and `61`
  carried a Google click ID;
- `39` were labelled Meta paid, but `19` had no paid-social medium and were
  referral/platform-touch evidence only.

The defect is in the upstream warehouse source classification inherited by
the certified candidate views. It does not invalidate the saved inquiry total
or selected-school fields. It does invalidate promotion of the current paid
channel breakdown.

The live Form 4 comparison for August 1-8 contained `474` non-test inquiries
and one excluded QA entry. Under the strict evidence rule, `68` had confirmed
Google paid evidence, `22` had confirmed Meta paid evidence, and another `20`
had Meta referral/platform-touch evidence that must not be called confirmed
paid without a governed campaign marker.

### 3. Daily freshness is working as a batch, but not declared clearly enough

At the comparison time, BigQuery was complete through August 7 with `439`
rows while live Gravity Forms included August 8 and had `474`. This is
consistent with the current daily refresh cadence, but a reader could mistake
the incomplete current day for a completed total.

Every Parent serving surface therefore needs an explicit `complete_through`,
`last_success_at`, `source_max_timestamp`, and `is_partial_day` contract.

### 4. Analytics foundations exist, but trained models do not

The live project contains 32 BigQuery datasets. All 32 were checked for
registered models and none exist.

Useful candidate surfaces already exist:

- `1,326` school-week demand forecast rows using `heuristic_v1`;
- `278` creative-theme candidate rows using `heuristic_v1`;
- `205` creative-fatigue rows using `heuristic_v1`;
- `32` MMM-readiness weeks, with zero Meridian-ready and zero Robyn-ready
  weeks;
- campaign forecasts, budget pacing, capacity-aware recommendations, growth
  opportunity scores, source readiness, and predictive contract catalogs.

These are valuable feature and decision-support foundations. They are not yet
trained predictive models. The creative source registry also shows Meta deep
detail only through 2026-07-19 and Google deep detail pending reconciliation.

### 5. The Cloud control plane exists but needs production discipline

The current project exposes five Cloud Run services, 14 Cloud Run jobs, and 12
Scheduler entries. Eight schedules are enabled and four Parent CRM/offline
activation schedules remain paused. Two regional `cefa-p4-id` services still
need ownership and traffic review before consolidation.

The committed Dataform package compiles and passed `18/18` assertions, but no
governed production Dataform release/workflow schedule exists. Production
runtime is also not yet recoverable from a CEFA-controlled private repository.

## Paid Evidence Contract V2

This contract is the first implementation gate.

### Evidence tiers

| Tier | Meaning | Examples |
|---|---|---|
| `confirmed_paid` | Evidence proves a paid acquisition touch | Valid `gclid`, `gbraid`, `wbraid`, approved paid medium, or governed Meta campaign/ad marker |
| `platform_touch_unverified` | A Meta click/referral touch exists but paid delivery is not proven | Bare `fbclid`, `fbc`, or Facebook/Instagram referral without a governed paid marker |
| `identifier_only` | A matching identifier exists but says nothing about acquisition source | `fbp` without Meta click/referral or campaign evidence |
| `non_paid_or_other` | Organic, GBP/local, direct, referral, email, AI, partner, or unknown | `google / organic`, `google / local_listing`, ordinary referral |

### Required rules

1. A valid Google Ads click ID is confirmed Google paid evidence even when
   UTMs are absent.
2. `google / organic` can never become paid merely because source is Google.
3. `google / local_listing` remains GBP/local unless separate paid evidence is
   present.
4. A paid-search medium is paid only under the appropriate platform/source or
   governed campaign mapping.
5. A bare Meta click marker is platform-touch evidence, not automatic proof
   of paid media.
6. `fbp` alone is matchability evidence and must not assign Meta, paid or
   organic source.
7. Meta is confirmed paid when paid-social or approved campaign/ad evidence
   is present.
8. Primary source, evidence tier, evidence type, platform touch, and platform
   attribution must remain separate fields.
9. Every row records `paid_evidence_contract_version`.

### Acceptance

- zero `google / organic` rows classified as confirmed paid;
- click-ID-only Google test classified as confirmed paid;
- bare Facebook referral test classified as platform-touch unverified;
- `fbp`-only test classified as identifier-only with no channel assignment;
- governed Meta paid-social test classified as confirmed paid;
- one saved entry remains one inquiry regardless of evidence tier;
- all loaded Parent history covered by the contract is reclassified;
- pre/post totals reconcile exactly and only channel allocation changes;
- candidate dashboards remain blocked until assertions pass.

## Execution Roadmap

### Now: Correctness And Production Control, 0-2 Weeks

| Priority | Work | Deliverable | Exit gate |
|---|---|---|---|
| `P0` | Implement paid evidence contract v2 in the private loader and semantic SQL | Versioned classifier, tests, evidence fields, migration note | All v2 assertions pass; August defect is gone |
| `P0` | Backfill Parent source classifications | Rebuilt raw-derived and candidate reporting rows | Saved-entry totals unchanged; channel deltas explained |
| `P0` | Add freshness and completeness watermarks | T+1 certified status plus optional intraday operational status | Prior day certified by 07:30 PT; partial day visibly labelled |
| `P0` | Add source-to-serving reconciliation | Daily Form 4 -> raw -> certified -> dashboard QA | Complete days reconcile 100%; tests excluded |
| `P0` | Close Parent sGTM operational acceptance | Meta browser/server ratio, dedup watch, Google transaction-ID diagnostics, runbook | No unexplained inflation or duplicate accepted IDs |
| `P1` | Productionize Dataform | Private Git, service identity, release config, workflow schedule, rollback | Critical graph compiles and runs on schedule |
| `P1` | Consolidate private runtime source | Reproducible Cloud Run/Dataform/Stape manifests without secrets | A clean environment can reproduce the approved deployment |
| `P1` | Strengthen observability | Freshness, volume, failure, dead-letter/replay, cost and PII alarms | Tested alerts and owner/runbook exist |
| `P1` | Promote reporting only after QA | Versioned Parent candidate and dashboard-owner signoff | v2 source, freshness and reconciliation gates pass |

The certified daily contract remains T+1 by default. If same-day operational
visibility is required, add a clearly labelled hourly/intraday layer; do not
silently redefine the certified daily contract as real time.

### Next: Business Outcome Spine, 2-8 Weeks

| Work | Required result |
|---|---|
| Supabase read-only discovery | Verified Parent outcome grain, exact identifiers, history, source timestamps, corrections, deletions, lineage, and freshness |
| GreenRope identity | Exact `cefa_event_id` and agreeing `cefa_form_entry_id` on one controlled prospective record |
| KinderTales/GreenRope boundary | Confirm which source creates and updates opportunity/outcome records and how one inquiry can create multiple school opportunities |
| Parent entity graph | Restricted adult, household, dependent, inquiry, opportunity, and school keys supporting multiple children and multiple legitimate inquiries |
| Outcome contract | Versioned tour scheduled, tour completed candidate, CRM closed won, and final enrollment evidence with separate source authority |
| Offline conversion activation | One idempotent secondary conversion per approved inquiry-stage-platform grain; no historical snapshot upload |
| Enhanced destination matching | Approved form-confirmed server path with transient normalized hashes; raw contact data never routed through GA4 or normal marts |
| Lifecycle reconciliation | Form 4, KinderTales, GreenRope/Supabase, Google, and Meta status with visible quarantine reasons |

Website inquiries remain primary conversion goals. CRM stages remain secondary
until volume, identity, business definition, and incrementality evidence justify
a separate bidding decision.

### Then: Governed Intelligence, 4-16 Weeks

#### Creative intelligence

1. Reconcile daily Meta and Google creative/ad/asset detail to platform totals.
2. Build stable creative, ad, campaign, school, audience, format, placement,
   theme, approval, and asset-version keys.
3. Preserve original copy and approved asset metadata without storing customer
   PII.
4. Join creative exposure and spend to saved inquiries, CRM outcomes, capacity,
   and controlled-test history.
5. Replace heuristic labels only after a reviewed theme taxonomy and labelled
   validation set exist.
6. Report confidence and sample size; never rank low-volume assets as winners.

#### Lead quality and scoring

1. Approve the target label first, such as tour scheduled or a later verified
   enrollment outcome.
2. Build point-in-time-correct features available before the prediction time.
3. Exclude prohibited sensitive and child-level attributes from targeting.
4. Establish a transparent baseline before a more complex model.
5. Train in BigQuery ML or another approved governed runtime.
6. Validate out of time and by province/school; measure calibration, lift,
   precision/recall, coverage, and stability.
7. Run in shadow and advisory mode before any audience or bidding use.

#### School demand and capacity forecasting

1. Reconcile weekly inquiries, qualified outcomes, spend, sessions, local
   demand, program interest, seasonality, school capacity, closures, and
   promotions.
2. Keep a seasonal-naive baseline beside every trained forecast.
3. Backtest rolling windows and report WAPE/error, bias, interval coverage, and
   low-history status.
4. Produce forecasts by school/week and program only where history supports
   the grain.
5. Keep capacity-aware budget recommendations advisory until capacity truth
   and outcomes are current.

#### Meridian MMM and incrementality

The current 32-week table is a readiness feature table, not an MMM result.
Before fitting Meridian, build:

- stable weekly channel spend and exposure history;
- consistent business outcomes, not only platform conversions;
- geography and school/capacity context;
- holidays, seasonality, promotions, openings/closures, pricing, and material
  operational controls;
- channel taxonomy and reconciliation across the full modeling period;
- ideally at least two years of comparable weekly history;
- planned geo or audience holdouts that can calibrate causal estimates.

Fit Meridian only after the readiness contract passes. Review priors,
posterior diagnostics, contribution intervals, holdout performance, and
sensitivity before using results for budget decisions.

### Later: Omnichannel Activation And Learning, 8+ Weeks

- ingest Mailchimp and GreenRope journey delivery/engagement read-only;
- connect messages, website return, inquiry, CRM progression, and enrollment
  at approved restricted identity grains;
- build suppression, re-engagement, and high-quality seed eligibility with
  explicit freshness and platform-policy checks;
- add campaign experiment and geo-lift history as a governed fact table;
- record recommendation, approval, action, and later outcome so CEFA learns
  whether its own decisions worked;
- evaluate value-based bidding only after secondary outcome quality and value
  definitions are stable;
- build Franchise Canada and Franchise USA sGTM independently when Parent and
  data-platform work is stable.

## Analytics Promotion Contract

No forecast, score, recommendation, or creative label may be promoted as a
trained model unless the model registry records:

- business question and decision owner;
- target label and source authority;
- training and evaluation windows;
- feature availability time and leakage checks;
- algorithm and version;
- baseline comparison;
- validation metrics and segment checks;
- calibration or interval coverage where applicable;
- freshness, drift, retraining, rollback, and expiry rules;
- advisory, reporting, activation, or autonomous-use eligibility.

Until then, current surfaces must display `heuristic`, `candidate`, or
`readiness` in their contract and remain non-autonomous.

## Dependencies And What They Block

| Dependency | Blocks | Does not block |
|---|---|---|
| Supabase operational access | Final business-outcome reconciliation and consolidated outcome history | Paid classifier correction, Dataform, Stape monitoring, creative source work |
| GreenRope exact IDs | Safe CRM stage matching and live offline conversion sending | Website inquiry tracking and aggregate reporting |
| KinderTales final enrollment identity | True enrollment-quality labels | Tour/CRM candidate reporting when exact identity exists |
| Approved capacity feed | Capacity-aware budget optimization | Demand and inquiry forecasting |
| Private runtime repository | Reproducible production release and recovery | Public contracts and read-only audits |
| Longer stable history | Trained forecasting and MMM confidence | Feature tables, baselines, readiness and experiment design |

## Program Acceptance

### Measurement

- saved Form 4 totals reconcile 100% on complete days;
- one saved inquiry has one stable event ID and no duplicate platform
  transaction identity;
- source classification v2 has zero known organic-as-paid cases;
- current-day and complete-through status are visible;
- platform attribution, first-party evidence, and business truth remain
  separate measures.

### Data platform

- production transformations are versioned and reproducible;
- critical Dataform assertions pass on every release;
- source freshness, lineage, failures, retries, and dead letters are visible;
- no raw parent/child PII appears in normal BigQuery, logs, or dashboards;
- current dashboards change only through reconciled, approved contracts.

### Outcomes and activation

- exact Form 4-to-business-outcome identity is proven per record;
- baseline/current-state CRM records are never uploaded as new events;
- accepted duplicate transaction IDs equal zero;
- website inquiry goals remain unchanged and primary;
- secondary outcomes appear in both platforms with recoverable delivery logs.

### Models

- a simple baseline exists for every model;
- trained models beat the approved baseline on out-of-time data;
- performance, calibration, intervals, drift, and segment coverage are visible;
- no model writes to campaigns or audiences without a separate approval gate;
- Meridian is not called ready until its data and diagnostic gates pass.

## Explicitly Not Doing Now

- changing KinderTales or School Manager delivery;
- replacing Gravity Forms as inquiry truth;
- routing raw contact data through GA4;
- using `fbclid` alone as proof of paid media;
- promoting the current paid-source candidate before v2 correction;
- calling heuristic tables trained AI models;
- enabling CRM-stage bidding or autonomous budget changes;
- backfilling historical CRM current-state snapshots as new conversions;
- delaying Parent correctness work for Franchise Stape rollout.
