# Marketing Data Intelligence Technical Walkthrough Presenter Guide

**Date:** 2026-08-04
**Owner:** CEFA marketing measurement
**Audience:** BI, digital transformation, technical reviewers, and marketing
**Meeting length:** 60 minutes
**Purpose:** Show the marketing-side system honestly, agree on the minimum
Supabase interface, and leave with practical next actions. This is not a
production-change meeting.

## Required Meeting Outcomes

By the end of the walkthrough, participants should understand:

1. which website, form, CRM, platform, and warehouse paths are live today;
2. which components are built but guarded or still waiting on dependencies;
3. why Supabase remains the consolidated business-data layer while BigQuery
   provides the marketing measurement and activation layer;
4. the minimum read-only business-outcome contract Marketing needs from
   Supabase;
5. how the operational health scorecard prevents silent failures and unsafe
   platform delivery;
6. who will supply the representative Supabase record and when the read-only
   proof of concept will be reviewed.

Do not use this meeting to enable platform delivery, change campaign bidding,
alter Supabase, or settle broad organizational ownership.

## Before The Meeting

Prepare these items in separate browser tabs before screen sharing:

- the approved presentation, with current-state and target-state labels;
- the one-tab current-state data overview;
- this presenter guide;
- the [program register](../00-governance/measurement-and-activation-program-register-2026-07-23.md);
- the [data taxonomy](../00-governance/data-taxonomy.md);
- the [operational health scorecard contract](../20-bigquery/measurement-activation-operational-health-scorecard-v1-2026-08-04.md);
- an aggregate read-only result from
  `cefa_ops.vw_measurement_activation_health_v1`;
- one synthetic or fully redacted example record showing the intended identity
  chain;
- the proposed minimum Supabase outcome fields, listed below.

Do not screen-share credentials, raw form entries, parent or child data,
contact hashes, click IDs, restricted payloads, browser sessions, API tokens,
or unrestricted logs.

## Opening Script - 0 To 5 Minutes

> Thank you for making the time. The goal today is to show the marketing side
> as it actually works, distinguish what is live from what is guarded, and
> agree on the smallest reliable connection we need with Supabase. This is a
> technical alignment session; we are not making production changes today.
>
> The business problem is straightforward. Advertising platforms can see an
> inquiry, but today they do not consistently see what happened after the
> inquiry. We are improving attribution, identity, reconciliation, and
> outcome feedback so reporting reflects real business outcomes and any future
> optimization is based on proven quality rather than form volume alone.
>
> Supabase remains the consolidated business-data environment. BigQuery is not
> becoming another CRM or parent database. It combines marketing events,
> advertising cost, attribution evidence, minimum approved business outcomes,
> quality controls, and governed platform activation.

Then state the meeting decisions you want:

> By the end, I would like us to agree on the representative Supabase record,
> the minimum read-only outcome fields, the initial daily incremental method,
> and the owner and date for the proof of concept.

## Business Flow - 5 To 15 Minutes

Show this simplified flow:

```text
Ad or marketing source
  -> website visit
  -> saved inquiry with stable event identity
  -> KinderTales or Synuma business delivery
  -> CRM / operational outcome
  -> Supabase business consolidation
  -> BigQuery marketing reconciliation and reporting
  -> secondary Google and Meta outcome feedback when eligible
```

Use this script:

> For parents, Gravity Forms Form 4 is the authoritative inquiry record.
> School Manager continues to own school, program, day, and KinderTales
> delivery. The tracking plugin adds attribution and a stable event identity;
> it does not replace that business logic.
>
> Franchise Canada and Franchise USA are separate paths with separate forms,
> events, analytics properties, advertising destinations, and Synuma delivery.
> They are not mixed with the parent flow or with each other.
>
> Existing website inquiry conversions remain live and primary. The new CRM
> stages are built as secondary reporting signals. They will not become
> bidding targets simply because they exist.

Be explicit about status:

- `Live`: Parent inquiry event and existing Google/Meta/GA4 destinations.
- `Live guarded`: Parent attribution improvements and franchise attribution
  shadow comparison.
- `Built but not sending`: Parent CRM outcome ledger, outbox, Google actions,
  Meta test events, diagnostics, and kill switches.
- `Waiting`: Exact GreenRope identity fields, controlled identity test,
  per-record eligibility, and the Supabase interface proof.
- `Approved, not routed live`: Stape Business server-side tagging.

## BigQuery Walkthrough - 15 To 27 Minutes

Show structure, not row-level private data:

```text
Source evidence
  -> standardized staging
  -> governed event and identity contracts
  -> reconciled marketing marts
  -> reporting and activation surfaces
  -> aggregate operational health
```

Use this script:

> BigQuery receives or will receive the sources that marketing must reconcile:
> native GA4 events, advertising delivery and spend, attributed inquiry
> evidence, minimum approved CRM outcomes, and platform-delivery results.
> This is where we can compare those systems without making an advertising
> platform or dashboard the business truth.
>
> Normal marketing tables do not hold raw names, phone numbers, emails, child
> details, addresses, CRM notes, or full parent profiles. Those remain in the
> operational systems and Supabase. Restricted processing uses pseudonymous
> identities and minimum match evidence only where required.
>
> Existing dashboard contracts are not replaced until reconciliation passes.
> New logic is developed in parallel and promoted deliberately.

Show only:

- dataset names and layer purpose;
- aggregate counts and freshness;
- schema field names from approved contracts;
- Dataform assertions and quality results;
- status labels from the program register.

Do not show:

- raw restricted rows or payloads;
- credentials, service-account keys, tokens, or Secret Manager values;
- individual family or franchise-candidate records;
- a dashboard candidate as though it were already certified.

## Example Record - 27 To 35 Minutes

Use synthetic values and narrate the intended chain:

```text
cefa_event_id
  -> form_entry_id
  -> inquiry_key
  -> school_uuid
  -> source opportunity ID
  -> canonical lifecycle stage and original timestamp
  -> one deterministic transaction ID per inquiry + stage + platform
```

Script:

> The stable website event ID lets us prove that the later outcome belongs to
> one saved inquiry. The form entry confirms the source submission. The school
> UUID preserves the school selected at inquiry time. The source opportunity
> and original business timestamp tell us what happened and when.
>
> If identity is missing or conflicting, only that record is quarantined. It
> is not guessed, and it does not delay eligible records. One inquiry may
> create multiple downstream opportunities, but the platform transaction is
> deduplicated at one accepted event per inquiry and canonical stage.

State the current limitation:

> The exact end-to-end Parent example cannot be called production-proven until
> the two CEFA identity fields are retained on the GreenRope opportunity and
> read back successfully. The components are ready, but that identity proof is
> still a gate.

## Operational Scorecard - 35 To 45 Minutes

Open the aggregate scorecard view. Explain that it is an operating control,
not a marketing-performance dashboard.

Use this read-only query during the screen share:

```sql
SELECT
  site_context,
  component,
  metric_key,
  health_status,
  current_value,
  threshold_definition,
  owner_role,
  breach_action
FROM `marketing-api-488017.cefa_ops.vw_measurement_activation_health_v1`
ORDER BY site_context, component, metric_key;
```

The query is aggregate-only. Keep the restricted source tables closed during
the meeting.

Use this script:

> Rafael recommended a deliberately small operating baseline, so we created
> exactly that: last successful sync, reconciliation, missing CEFA IDs,
> duplicate transactions, Google and Meta delivery status, and current
> quarantine. Every metric has a threshold, owner, and response action.
>
> `NOT_ACTIVE` means a route is intentionally disabled and is not a failure.
> `NOT_INSTRUMENTED` means the route exists or is active, but still needs to
> write its aggregate run totals. Green means the evidence is within the
> agreed threshold. Amber means investigate while the record or route remains
> contained. Red means follow the relevant runbook and stop only the affected
> delivery path unless the issue is global.
>
> The current read is honest: platform outcome routes are not active, Form 4
> capture still needs run instrumentation, and six existing school-identity
> quarantines are visible as red. No sender was enabled to create this view.

### What Marketing Will Do With The Scorecard

Before activation:

1. connect each active runtime to write one aggregate terminal run row;
2. investigate and classify the six existing `unknown_school_uuid`
   quarantines without exposing the underlying records;
3. run synthetic success, reconciliation-failure, duplicate, delivery-failure,
   and kill-switch tests;
4. connect alert delivery only after the status logic is proven;
5. require a second person to execute each runbook successfully.

During guarded production:

1. review the scorecard daily for the initial stabilization period;
2. investigate amber without replaying blindly;
3. stop only the affected route on red and preserve source evidence;
4. confirm `records_read = loaded + quarantined + rejected` before replay;
5. record the incident, resolution, and proof of recovery.

After stabilization:

1. review operational health weekly and formally review thresholds monthly;
2. use alerts for immediate failures rather than relying on manual checking;
3. keep the scorecard aggregate-only and separate from campaign-performance
   reporting;
4. add a metric only when it has a clear failure decision and owner.

Global stop conditions are accepted duplicate transactions, prohibited data
in marketing tables or logs, historical/baseline records being uploaded as
new outcomes, wrong stage mappings, or cross-property delivery.

## Supabase And BigQuery Interface - 45 To 55 Minutes

Use this script:

> The launch proposal is a small daily incremental read of new or changed
> business outcomes. It is not a full-table scan. Every record keeps its
> original business timestamp. If faster feedback later becomes valuable, we
> should use a webhook or outbox rather than poll Supabase more aggressively.
>
> BigQuery does not need complete profiles. It needs the minimum record-level
> facts required to reconcile an inquiry to an outcome and prevent duplicate
> activation. Supabase can continue to consolidate operational truth and use
> certified aggregate marketing summaries if those are useful for internal
> reporting.

Proposed minimum fields to inspect, not impose before seeing the schema:

| Need | Example contract |
|---|---|
| Stable inquiry identity | `cefa_event_id`, `cefa_form_entry_id`, or a documented deterministic bridge |
| Business record identity | Stable opportunity/outcome ID and source system |
| Relationship grain | Parent, inquiry, opportunity, school, and enrollment relationships |
| Outcome | Canonical status/stage plus source status |
| Time | Original outcome timestamp, source update timestamp, and ingestion timestamp |
| School | Canonical `school_uuid` or a governed mapping key |
| Corrections | Changed/deleted indicator, replacement relationship, or source version |
| Lineage | Source table/system and schema version |

Ask Thiago to show or confirm:

1. What is the grain of each relevant table: person, inquiry, opportunity,
   school relationship, or enrollment?
2. Which stable identifiers survive from website inquiry to CRM and final
   outcome?
3. Is stage history retained, or only the current stage?
4. Are original stage timestamps retained separately from pipeline update
   timestamps?
5. How are corrections, merges, deletions, repeat inquiries, multiple children,
   and multiple schools represented?
6. What school identifier is available and how is it mapped?
7. What field reliably identifies new or changed records for an incremental
   read?
8. Which read-only interface is simplest for the proof of concept: view, API,
   or controlled export?
9. Can one synthetic or redacted record be traced from source through
   Supabase?
10. What freshness and failure evidence does the current Supabase pipeline
    expose?

## Close And Decisions - 55 To 60 Minutes

Use this script:

> To summarize, existing conversion tracking remains unchanged. The marketing
> warehouse and health controls continue in parallel. Production CRM outcome
> delivery remains guarded until exact identity, source timestamps,
> eligibility, deduplication, diagnostics, and rollback tests pass.
>
> The decisions I would like to record today are: the representative Supabase
> record, the minimum fields, the read-only proof-of-concept method, the person
> providing access or the export, and the date for the Supabase-side review.

Read back the decisions before ending. Assign one owner and one due date to
each action. Do not leave with only a general agreement to collaborate.

## Likely Questions And Short Answers

### Why not build all of this in Supabase?

Supabase remains the consolidated business-data layer. BigQuery already has
native Google analytics and advertising sources and is designed for large
cross-source analytical, reconciliation, Dataform, and activation workloads.
Using a minimum interface avoids copying complete operational profiles or
rebuilding marketing platform pipelines inside Supabase.

### Are we creating a competing source of truth?

No. Supabase owns consolidated business records and outcomes. BigQuery owns
marketing evidence, attribution, reconciliation, measurement marts, and
governed platform feedback. Platform-reported conversions are never treated
as business truth.

### Is raw parent or child data stored in BigQuery?

Not in normal marketing tables. Raw names, contact details, addresses, child
details, notes, and complete CRM records stay in operational systems and
Supabase. Restricted processing uses minimum pseudonymous identity evidence
where required.

### Is the CRM outcome system live?

The ledger, outbox, Google actions, Meta test events, diagnostics, and kill
switches are built. Production sending is disabled until the remaining
identity, eligibility, controlled-test, and operating gates pass.

### Will CRM outcomes change campaign bidding?

No. They launch as secondary reporting signals. Promotion into bidding is a
later campaign- or location-specific decision after volume, lag, quality, and
incrementality are proven.

### What if enrollment takes longer than 60 days?

That is why the design starts with measurement and intermediate lifecycle
stages. We will measure the verified lag distribution before deciding which
signal, if any, is timely enough for bidding.

### Do Google campaigns need 30 or 50 conversions first?

Those are not universal hard launch rules. The new signals remain secondary
while volume and quality are measured. Any bidding transition will be decided
individually using observed campaign/location evidence.

### How do duplicates get prevented?

Each accepted platform event has a deterministic transaction identity based
on inquiry, stage, and destination. Retries retain that identity, and accepted
locks prevent a retry from becoming another conversion.

### What happens when a record cannot be matched safely?

Only that record is quarantined with a machine-readable reason. It is not
guessed or sent, while other eligible records can continue.

### What happens when a platform or pipeline fails?

The scorecard shows the failed component, the affected route is stopped, the
source evidence is preserved, and the applicable short runbook is followed.
Unrelated routes continue only when isolation is proven.

### Will these controls delay the project?

No. They are being built in parallel. They delay only an unsafe production
send, not attribution, BigQuery, Stape, GA4 export, Supabase inspection, or
reporting work.

### Why use Stape if BigQuery already exists?

They solve different problems. Stape is the first-party server-side transport
for website events and destination delivery. BigQuery is the durable
measurement, reconciliation, intelligence, and activation-control layer.

### What is the initial Supabase synchronization frequency?

Daily at launch, using only new or changed records. A faster future path would
use a webhook or outbox if the business value justifies it.

### What is the estimated Google Cloud cost?

The approved planning amount is approximately CAD 3,377 annually for the
relevant Google Cloud services. Usage is metered, and the current scale is
expected to remain within that envelope.

### Who owns the project?

Marketing is responsible for the marketing measurement and activation layer.
Interfaces or changes involving Supabase, IT-managed infrastructure, DNS, or
operational systems are reviewed and implemented collaboratively with the
responsible team.

## Follow-Up Message Template

> Thank you for the walkthrough today. We confirmed the current marketing
> flow, the live-versus-guarded boundaries, and the purpose of the operational
> health scorecard. We agreed to use [interface] for a read-only proof of
> concept using [synthetic/redacted record], with [owner] providing [fields or
> access] by [date]. Marketing will prepare the minimum outcome contract and
> reconciliation result for review on [date]. No production conversion,
> bidding, Supabase, KinderTales, Synuma, or CRM-delivery change was made in the
> session.
