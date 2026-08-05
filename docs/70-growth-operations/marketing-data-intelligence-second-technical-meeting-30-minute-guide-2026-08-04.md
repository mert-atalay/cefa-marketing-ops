# Marketing Data Intelligence Second Technical Meeting - 30-Minute Guide

**Date:** 2026-08-04
**Meeting:** Second technical follow-up after the architecture presentation
**Length:** 30 minutes
**Owner:** CEFA marketing measurement

## Meeting Goal

Do not repeat the presentation or explain the entire architecture again.

Use this meeting to:

1. show the practical controls added since the first meeting;
2. confirm the minimum data CEFA needs from the business-outcome side;
3. agree on the read-only proof-of-concept method, owner, and date.

No production conversion, campaign, Supabase, KinderTales, GreenRope, Synuma,
or bidding change should be made during the meeting.

## What To Have Open

Open only these three items before the call:

1. the current-state/program status page;
2. the aggregate operational scorecard result;
3. one synthetic identity-and-outcome example.

Keep the longer [presenter guide](./marketing-data-intelligence-technical-walkthrough-presenter-guide-2026-08-04.md)
available only as a backup for detailed questions. Do not reopen the full deck
unless someone asks for a specific slide.

## 0 To 3 Minutes - Opening

> Thanks again. Since we already covered the full architecture and business
> purpose in our first meeting, I will not repeat the deck today.
>
> I would like to use this session for three practical items: briefly show the
> operational controls added since then, confirm the minimum outcome data we
> need from the business-data side, and agree on the read-only proof of concept
> and next owner.
>
> Existing website conversions and business-delivery paths remain unchanged,
> and we are not making a production change in this meeting.

## 3 To 7 Minutes - What Changed Since Meeting One

Show one status page, not the architecture deck.

> Since the first meeting, we added the small operational baseline Rafael
> suggested: an aggregate health scorecard, initial thresholds and response
> actions, plus three short runbooks for pipeline, data-quality, and platform-
> delivery failures.
>
> We also verified that the Franchise Canada and USA native GA4 exports are
> now receiving data. The existing website conversions remain unchanged. The
> new CRM outcome routes remain guarded and are not sending production events.

If time is tight, omit the franchise sentence and move directly to the
scorecard.

## 7 To 14 Minutes - Show The Scorecard

Run or show the saved result of this aggregate-only query:

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

Use this explanation:

> This is not a campaign-performance dashboard. It is the operational check
> that tells us whether the measurement and delivery routes are healthy.
>
> `NOT_ACTIVE` means the route is intentionally disabled.
> `NOT_INSTRUMENTED` means we still need to connect that runtime's aggregate
> run totals. Green is healthy, amber requires investigation while the data
> stays contained, and red follows a defined runbook.
>
> The current view is intentionally honest. The platform outcome routes are
> not active, Form 4 capture still needs runtime instrumentation, and six
> existing school-identity quarantines are visible for investigation. Creating
> this scorecard did not enable a sender or alter current conversions.

Explain how it will be used in one sentence:

> Before activation we use it to pass the synthetic failure and rollback
> tests; during early production we check it daily, and after stabilization it
> becomes a weekly operating check with automated failure alerts.

Do not open the restricted source rows during the meeting.

## 14 To 24 Minutes - Minimum Data And Interface Decision

Do not review the entire data model. Show one synthetic chain:

```text
cefa_event_id
  -> form_entry_id
  -> inquiry / opportunity ID
  -> school_uuid
  -> lifecycle outcome
  -> original outcome timestamp
  -> source update timestamp
```

Say:

> This is the minimum chain Marketing needs to match one saved inquiry to one
> real outcome without copying complete parent or child profiles into
> BigQuery.
>
> The launch proposal is a small daily incremental read of new or changed
> outcomes. It is not a full-table scan. If faster feedback becomes valuable
> later, a webhook or outbox is preferable to aggressive polling.

Ask only these five questions:

1. Which Supabase or source record represents the inquiry, opportunity, and
   final outcome, and what is the grain of each record?
2. Can `cefa_event_id` and `cefa_form_entry_id` be retained and returned, or
   what exact deterministic bridge is available today?
3. Are original stage timestamps and stage history retained, separately from
   the latest pipeline-update timestamp?
4. How are corrections, duplicates, repeat inquiries, multiple schools, and
   deleted or merged records represented?
5. What is the simplest read-only proof-of-concept interface: a controlled
   view, API response, or export of one synthetic/redacted record?

If KinderTales/GreenRope representatives are present, add one question:

> Can the CEFA event and form-entry IDs travel with the opportunity and be
> returned through the API or a separate signed lifecycle webhook without
> changing the existing KinderTales or AWS delivery path?

## 24 To 28 Minutes - Record Decisions

Complete this aloud:

| Decision | Meeting answer |
|---|---|
| Representative table/record | |
| Stable identity bridge | |
| Original outcome timestamp | |
| Read-only interface | |
| Person providing access/example | |
| Proof-of-concept review date | |

If an answer is unknown, record the person who will confirm it and a date.

## 28 To 30 Minutes - Close

> To summarize, current website conversions and business-delivery paths remain
> unchanged. Marketing will continue the measurement and operational-control
> work. The next shared step is the read-only proof of concept using the agreed
> record and minimum fields.
>
> I will send a short written recap with the decisions, owners, and dates. No
> production CRM outcome delivery will be enabled until the exact identity,
> timestamp, deduplication, platform diagnostics, and rollback checks pass.

## Likely Questions - Short Answers

**Why is BigQuery needed if Supabase has business data?**

Supabase remains the business-data layer. BigQuery combines that minimum
outcome with GA4, Google Ads, Meta, attribution, cost, reconciliation, and
platform-delivery evidence without copying complete operational profiles.

**Is this already sending CRM outcomes to Google or Meta?**

No. The destinations and guarded machinery exist, but production outcome
delivery remains disabled.

**Will this change campaign bidding?**

No. CRM outcomes begin as secondary reporting signals. Any future bidding
change requires separate campaign- or location-level evidence and approval.

**Is parent or child PII being stored in normal BigQuery tables?**

No. Complete profiles and raw parent/child data remain in operational systems
and Supabase. Marketing uses minimum pseudonymous identity and outcome facts.

**Will the health controls delay the project?**

No. They are already being built in parallel. They block only an unsafe
production send.

**What happens when a record cannot be matched?**

Only that record is quarantined with a reason. It is not guessed or sent, and
eligible records do not need to wait.

## Scorecard Action After The Meeting

Marketing's immediate scorecard actions are:

1. instrument the active Form 4 capture runtime;
2. investigate and classify the six current `unknown_school_uuid`
   quarantines;
3. run synthetic success, reconciliation-failure, duplicate, platform-
   failure, and kill-switch tests;
4. connect automated alerts after the status logic is proven;
5. use the scorecard as the go/no-go evidence before enabling each outcome
   delivery route.
