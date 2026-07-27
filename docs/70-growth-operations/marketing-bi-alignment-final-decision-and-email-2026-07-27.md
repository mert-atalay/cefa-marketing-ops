# CEFA Marketing And BI Alignment Final Decision

**Decision date:** 2026-07-27

**Status:** Approved architecture and meeting position; not production
authorization

**Decision owner:** CEFA marketing operations

**Scope:** Parent marketing measurement, Supabase/BigQuery boundary, Stape,
and CRM outcome activation

## Purpose

This document closes the architecture review initiated by the
[independent-review brief](./marketing-bi-alignment-independent-review-brief-2026-07-27.md).
It records the position CEFA will take into the BI alignment meeting, the
execution changes accepted from the review, and the final stakeholder email.

The architecture debate is closed unless the BI meeting reveals materially
different source behavior. The remaining work is evidence, ownership,
contract definition, and controlled implementation.

## Final Architecture Decision

1. Supabase is CEFA's consolidated Parent business-data layer as reported by
   the BI team. The exact schema, record grain, lineage, history, identifiers,
   freshness, and pipeline behavior remain pending read-only verification.
2. BigQuery remains CEFA marketing's event, attribution, reconciliation,
   intelligence, semantic, and platform-activation layer.
3. KinderTales and GreenRope remain operational sources. Supabase consolidates
   their approved Parent business outcomes; it does not replace their
   operational authority.
4. BigQuery will receive only the minimum record-level Parent outcomes needed
   for reconciliation, attribution, and approved activation. It will not
   become a second CRM or copy complete parent, child, admissions, contact, or
   note records.
5. Direct marketing evidence continues to enter BigQuery without waiting for
   Supabase. This includes GA4 raw events, platform delivery and spend,
   website attribution and event identity, Stape diagnostics, SEO/local data,
   partner evidence, campaign operations, and approved budget context.
6. Certified marketing summaries may flow from BigQuery to Supabase or Power
   BI under a shared metric dictionary.
7. Parent, Franchise Canada, and Franchise USA remain separate domains,
   properties, forms, destinations, CRM paths, event taxonomies, and
   activation contracts.

## Execution Decision

The program runs in two parallel tracks with independent production gates.

### Track A: Parent business outcomes and offline conversions

1. Create GreenRope opportunity fields `cefa_event_id` and
   `cefa_form_entry_id`.
2. Complete one controlled Form 4, KinderTales, GreenRope, and existing
   conversion read-back.
3. Resolve per-record platform eligibility and retain fail-closed behavior
   when eligibility is unknown.
4. Activate eligible prospective GreenRope CRM-stage outcomes only after the
   existing baseline, deduplication, validation, diagnostics, and kill-switch
   gates pass.
5. Inspect the BI Supabase pipeline and approve a versioned
   Supabase-to-BigQuery Parent outcome contract.
6. Reconcile Supabase outcomes against the current direct GreenRope evidence
   before changing source authority.

The existing guarded GreenRope CRM reporting path does not wait for Stape or a
Supabase source switch. A Supabase cutover is a separate source-authority
change and cannot re-upload the historical/current-state GreenRope baseline.

### Track B: Website measurement and Stape

1. Confirm CEFA administrative ownership, recovery, container entitlement,
   and billing access.
2. Establish property-isolated first-party endpoints for Parent, Franchise
   Canada, and Franchise USA.
3. Build Parent first in preview and shadow.
4. Prove GA4 parity, Google once-only delivery, Meta Pixel/CAPI
   deduplication, destination isolation, and business-delivery continuity.
5. Promote one property at a time with a tested rollback.

Stape does not block Track A activation. Track A does not authorize Stape
promotion.

### Shared production spine

- CEFA-controlled private runtime source;
- Dataform Git, release, assertion, and parity workflow;
- monitoring, alerts, queues, dead-letter handling, replay, and runbooks;
- source, deployment, and delivery ledgers;
- shared school, identity, metric, and source contracts.

## Consent Decision

- Consent-state and platform-eligibility fields must travel through the Stape
  request and activation contracts.
- Server transport must never convert an unknown or ineligible event into an
  eligible event.
- Consent-dependent user-data matching, Customer Match, audience delivery,
  and similar features remain disabled until separately approved.
- CMP procurement and production implementation remain deferred by CEFA.
- Stape must be consent-capable now, but the deferred CMP purchase is not a
  blocker for approved base first-party routing and diagnostics. Destination
  delivery remains governed by the available per-record eligibility state.
- Normal marketing datasets and logs contain no raw parent or child PII.
  Any later approved matching uses a restricted, transient path.

## Supabase Source-Switch Gate

Supabase can become the primary consolidated Parent business-outcome feed only
after all of the following are verified:

- one row per business outcome, not aggregate-only totals;
- exact `cefa_event_id` and `cefa_form_entry_id` coverage or an approved
  deterministic source link;
- stable source opportunity, inquiry, contact, and enrollment identifiers;
- preserved original business timestamps and append-only stage history;
- clear separation of GreenRope `crm_closed_won` from final KinderTales
  enrollment truth;
- multi-child, repeat-inquiry, multi-school, merge, correction, and deletion
  behavior;
- incremental cursor, freshness, retry, and replay contracts;
- row-count, duplicate, source-parity, and identity assertions;
- one production sender, accepted-ID reconciliation, and named rollback
  ownership.

Until that gate passes, direct GreenRope reads may support guarded activation,
parity, diagnosis, and fallback. They must not compete with a second sender.

## Immediate Meeting Outcomes

The meeting should produce:

1. a read-only demonstration of the KinderTales/GreenRope-to-Supabase
   pipeline;
2. the relevant Parent tables, keys, grain, history, timestamps, corrections,
   and freshness;
3. one shared definition sheet for inquiry, tour, CRM closed won, final
   enrollment, paid attribution, and school ownership;
4. the minimum Supabase-to-BigQuery record-level outcome feed;
5. the minimum BigQuery-to-Supabase/Power BI certified marketing summary;
6. named owners, proof-of-concept record, monitoring, SLA, and next actions.

No production source switch happens as part of the meeting. Deployment follows
a verified proof-of-concept record and the applicable promotion gates.

## Later Gated Additions

### Phone attribution discovery

First quantify phone-originated inquiries, tours, and enrollments using
existing operational evidence and a defined staff/process capture period.
GreenRope source labels alone do not identify calls that never reached a web
form. Consider a controlled dynamic-number-insertion pilot only if evidence
shows a material blind spot. No vendor or percentage threshold is approved.

### Incrementality

Use CEFA's school and market structure for controlled tests only after outcome,
capacity, and calendar evidence is reliable. Tests require matched markets,
capacity controls, seasonality and pre-period baselines, minimum sample rules,
approved budget changes, and a recorded decision. School count alone does not
make locations interchangeable test cells.

### Value-based optimization

Keep the current CRM-stage conversions count-only and secondary. Introduce
values only from Supabase/KinderTales-verified final enrollment truth and an
approved economic model. GreenRope `crm_closed_won` is not sufficient.
Reconciliation, deduplication, volume, value-model approval, and bidding
approval are promotion gates; elapsed time alone is not.

### US Local Services Ads

Treat this only as a future eligibility check for participating US local
schools. It does not apply to Franchise USA recruitment and is not part of the
current implementation plan. Recheck Google's current category, market,
business-profile, and verification requirements before any pilot.

## Unchanged Production Boundaries

- Form 4 remains the authoritative saved Parent inquiry.
- School Manager and KinderTales delivery remain unchanged.
- Existing website inquiry conversions remain primary.
- New CRM-stage conversions remain secondary and non-biddable.
- Current campaigns, budgets, bidding, forms, and conversion goals do not
  change from this decision.
- Platform conversion totals do not become business truth.
- No production sender, source switch, audience, or bidding change is
  authorized by this document alone.

## Final Send-Ready Email

**Subject: Parent marketing measurement and Supabase - alignment before our
meeting**

Hi [name],

Thanks for the context on the Supabase warehouse. This is genuinely good news
and closer to our plans than the questions might suggest. Below are short
answers to the three main points, followed by a proposed running order for the
meeting.

**On the duplicate database: agreed, and it will not happen.** For the Parent
funnel, Supabase already serves as CEFA's consolidated business-data layer,
bringing together what KinderTales and GreenRope, the operational systems,
record. We only need to verify the record-level fields, history, and
identifiers needed for the marketing connection.

We will not copy customer profiles, CRM records, or admissions operations into
BigQuery, and our governance explicitly forbids creating a second CRM. What we
propose is one narrow connection in each direction:

- Supabase provides a small, read-only, record-level feed of Parent-funnel
  outcomes, such as stage changes and enrollment outcomes, with their IDs and
  original business timestamps.
- BigQuery provides certified marketing summaries back to Supabase or Power
  BI, so your dashboards receive spend and campaign context without your team
  maintaining ad-platform connectors.

The normal outcome export contains no names, child details, or ordinary
contact information. If hashed matching data is ever approved, it will use a
separate restricted and transient path. Franchise data remains on its own
Synuma/SiteZeus path and is outside this Parent alignment.

**On daily processing: agreed on frequency.** Daily works as the minimum
cadence for the outcome feed, with same-day preferred and faster processing
only if it proves useful. The original business timestamp must remain attached
to every record regardless of processing frequency.

The important distinction is frequency versus level of detail. Daily batches
are fine, but they must contain individual records rather than only totals.
The advertising platforms receive outcomes one record at a time with eligible
matching evidence and CEFA's stable transaction identity for duplicate
protection. Connecting an enrollment to the inquiry and marketing evidence
that preceded it also requires the individual inquiry identity. A total such
as "4 enrollments last week" cannot be decomposed back into that. In short:
process daily, but keep the rows.

**On whether BigQuery is necessary: yes, for three practical reasons.** GA4's
raw website-event export lands natively in BigQuery; the ad-platform imports
and safety-gated offline-conversion machinery are already built and
validation-tested there, with production dispatch still disabled behind
explicit safety gates; and current usage remains well inside the approved
capacity envelope. BigQuery also keeps high-volume marketing-event processing
separate from the database serving Power BI.

Supabase tells us what happened in the business. BigQuery connects those
outcomes to marketing evidence, applies CEFA's governed attribution rules, and
reports approved outcomes back to Google and Meta through one deduplicated
sender.

**Proposed running order for the meeting, 45-60 minutes:**

1. We walk through the complete marketing measurement program: conversion
   truth, attribution, BigQuery/Dataform, Stape, and the offline-conversion
   safety gates.
2. Your team demonstrates the Supabase side: KinderTales/GreenRope ingestion,
   table grain and keys, stage history, original timestamps, custom-field
   handling, refresh behavior, and monitoring.
3. Both teams inspect identity and outcome grain and define the minimum
   connection in each direction.
4. We agree one shared definition sheet for inquiry, tour, enrollment, paid
   attribution, and school ownership so Power BI and marketing reporting
   cannot silently use different definitions.
5. We close with named owners, a proof-of-concept record, and next actions.

No production source switch happens as part of the meeting. Any deployment
follows a verified proof-of-concept record and the agreed promotion gates.

Best,

Mert
