# CEFA Parent Omnichannel Vendor API Request

**Date:** 2026-07-25
**Status:** Vendor-ready requirements
**Scope:** Parent inquiries on `cefa.ca`, GreenRope, and
School Manager/KinderTales
**Canonical plan:** [Google Cloud and Stape measurement platform
blueprint](../superpowers/plans/2026-07-25-google-cloud-stape-measurement-platform-blueprint.md)

## Purpose

CEFA needs stable source identifiers and timestamped lifecycle evidence so one
website inquiry can be connected to the correct CRM opportunity, household,
child need, school, email journey, tour, and later operational outcome.

CEFA is not requesting a bulk copy of parent or child records. Names, raw email
addresses, raw phone numbers, exact child birth dates, addresses, notes, and
message bodies are not required in the marketing warehouse. Source identifiers
will be converted to restricted HMAC keys before analytics use.

## Current Confirmed CEFA Flow

CEFA already knows that WordPress creates the operational inquiry:

```text
Gravity Forms Form 4
  -> CEFA School Manager
  -> KinderTales public CRM inquiry API
```

That payload already carries parent/child operational details, school,
program, days, referral, and Form 4 attribution fields `35-46`. It does not
currently carry `cefa_event_id`, `cefa_form_entry_id`, or the attribution
schema version.

The unconfirmed step is whether the KinderTales inquiry automatically creates
or updates the corresponding GreenRope contact/opportunity. CEFA is therefore
asking the same vendor to document the full KinderTales-to-GreenRope handoff,
not to rediscover the known WordPress integration.

## GreenRope Request To Send Now

Please create these two GreenRope **opportunity custom fields** as Short Text:

1. `cefa_event_id`
2. `cefa_form_entry_id`

Requirements:

- preserve the names exactly;
- expose both fields through the opportunity API for read and write;
- do not make them required for staff-created opportunities;
- do not attach assignment, stage, journey, email, or workflow behavior to
  the fields;
- confirm the field dictionary/API names after creation;
- confirm whether the KinderTales inquiry API creates or updates the GreenRope
  contact/opportunity directly or through an asynchronous vendor sync;
- map both values through that existing path, or provide the correct supported
  GreenRope create/update endpoint if no such sync exists;
- return or expose the stable GreenRope `contact_id` and `opportunity_id`;
- confirm that retries with the same `cefa_event_id` will update or resolve the
  same opportunity instead of creating a duplicate.

Source mapping:

| CEFA source | GreenRope destination |
|---|---|
| Gravity Forms Form 4 field `32.4` | `cefa_event_id` |
| Saved Gravity Forms entry ID | `cefa_form_entry_id` |

The Gravity Forms entry ID is created server-side after the form saves. It
cannot be trusted as a browser-prefilled hidden value.

## GreenRope Horizon API Request

Please confirm the supported API objects, endpoint names, permissions,
pagination, rate limits, timestamp fields, and webhook options for:

- contacts and stable `contact_id`;
- opportunities and stable `opportunity_id`;
- group/location identity and its relationship to CEFA schools;
- opportunity field dictionary;
- phase and phase-path dictionary;
- lifecycle stage changes and their source timestamps;
- CRM email activities;
- customer-journey definitions;
- contact journey membership and step progression;
- subscription, bounce, unsubscribe, and complaint state where GreenRope is
  the sending system.

CEFA's current capability notes reference:

- `GetOpportunityFieldsRequest`
- `GetPhasesRequest`
- `GetPhasePathsRequest`
- `GetCRMActivitiesEmailsRequest`
- `GetAllCRMActivitiesEmailsRequest`
- `GetJourneysRequest`
- `GetAllJourneysRequest`

Please confirm whether these are still the correct production endpoints and
provide their current field dictionary.

### Required GreenRope event fields

| Category | Required evidence |
|---|---|
| Identity | `contact_id`, `opportunity_id`, `cefa_event_id`, `cefa_form_entry_id` |
| School/program | GreenRope group/location ID, CEFA `school_uuid` where supported, program ID where supported |
| Lifecycle | phase/stage ID, phase/stage name, transition timestamp, modified timestamp |
| Email | email activity ID, campaign/message ID, journey ID, journey step ID, status/action, event timestamp |
| Delivery status | sent, delivered when available, bounced, clicked, unsubscribed, complained |
| API operations | stable pagination cursor, `modified_since` or equivalent incremental filter, UTC timestamp definition |

Email opens may be supplied but CEFA will treat them as low-confidence
diagnostics rather than intent or qualification.

### GreenRope relationship questions

Please answer:

1. Can one contact have multiple active opportunities for different children,
   schools, programs, or start periods?
2. Does GreenRope have stable household or dependent/child IDs? If yes, expose
   only those IDs and relationship edges in the safe integration.
3. If no household/child model exists, can each opportunity retain its own
   program, school, and inquiry identity without collapsing other
   opportunities for the same contact?
4. Can a workflow webhook send an HMAC-signed event for phase change, email
   click, journey entry, journey step, and journey exit?
5. How are contact merges, opportunity merges, deletions, and reassignment
   represented through the API?

GreenRope is not required to become CEFA's household or final enrollment
authority. If it does not have a reliable household/child relationship, CEFA
will use School Manager/KinderTales for that layer.

## Consolidated Technical Questions For The Vendor

CEFA may send this as one list when KinderTales and GreenRope are supported by
the same vendor:

1. Does the current KinderTales inquiry API request create or update a
   GreenRope contact and opportunity?
2. If yes, is that operation synchronous or asynchronous, and which service or
   integration owns it?
3. If no, what currently creates the GreenRope parent opportunity?
4. Can the KinderTales inquiry `metaData` accept `cefa_event_id`,
   `cefa_form_entry_id`, and `cefa_attribution_schema_version` without
   changing routing or workflows?
5. Can those exact values be copied to GreenRope opportunity fields during
   opportunity creation?
6. Please create GreenRope Short Text opportunity fields named exactly
   `cefa_event_id` and `cefa_form_entry_id`. What are their API field names?
7. Does the KinderTales response return stable inquiry, parent, household,
   child, school, and program IDs? If not, can they be looked up later by
   `cefa_event_id`?
8. Can the same response or lookup return the related GreenRope `contact_id`
   and `opportunity_id`?
9. How does the integration prevent duplicate KinderTales inquiries,
   GreenRope contacts, and GreenRope opportunities when CEFA retries the same
   `cefa_event_id`?
10. Can one parent/contact retain separate inquiries or opportunities for
    multiple children, schools, programs, and requested start periods?
11. Which system is authoritative for parent, household, child, inquiry,
    opportunity, school, program, tour, waitlist, and enrollment identity?
12. Which timestamp represents inquiry creation and each lifecycle transition,
    and are timestamps returned in UTC?
13. Which APIs, incremental exports, or signed webhooks expose inquiry,
    contacted, tour scheduled, tour completed, waitlisted, enrolled, and
    closed/lost events?
14. Which GreenRope APIs expose phases, phase paths, CRM email activity,
    journeys, journey membership, delivery, click, bounce, unsubscribe, and
    complaint events?
15. What authentication, pagination, rate limits, incremental cursor or
    `modified_since` behavior, retry rules, webhook signatures, and test
    environment are supported?
16. How are contact merges, household changes, opportunity merges,
    reassignment, corrections, and deletions represented?
17. Can CEFA receive only stable IDs, relationship edges, statuses, and
    timestamps for analytics, without exporting raw parent or child PII?

## KinderTales And School Manager Request

### Immediate metadata confirmation

Please confirm whether
`POST https://crm-api.kindertales.com/public/crm/inquiries` accepts these
additional `metaData` keys without changing current inquiry routing:

- `cefa_event_id`
- `cefa_form_entry_id`
- `cefa_attribution_schema_version`

Please also confirm whether the response returns a stable:

- `kindertales_inquiry_id`;
- parent/guardian ID;
- household/family ID, if the product has one;
- child/dependent ID;
- school/location ID;
- program ID.

If those IDs are created asynchronously, please provide a supported lookup by
`cefa_event_id` or a signed webhook that returns them later.

### Safe read/export contract

For the later omnichannel phase, CEFA requests a read-only API, incremental
export, or signed webhook with:

| Entity or event | Required safe fields |
|---|---|
| Inquiry | stable inquiry ID, `cefa_event_id`, `cefa_form_entry_id`, created/modified timestamps |
| Adult contact | stable parent/guardian ID only |
| Household | stable household/family ID and adult/child relationship edges, if available |
| Child/dependent | stable child ID only; no name, exact birth date, address, or notes |
| School/program | existing CEFA `school_uuid`, stable program ID, requested start period where available |
| Lifecycle | inquiry received, contacted, tour scheduled, tour completed, waitlisted, enrolled, closed/lost, event timestamp |
| Data maintenance | merge, reassignment, deletion, correction, and source-version evidence |

Required API behavior:

- UTC timestamps with documented meaning;
- incremental `modified_since`, cursor, or webhook delivery;
- pagination and rate-limit documentation;
- idempotent delivery or stable event IDs;
- HMAC signature or equivalent webhook verification;
- replay/retry behavior;
- test environment or controlled test procedure;
- no requirement to export raw names, emails, phones, addresses, exact birth
  dates, notes, or child records to the marketing warehouse.

KinderTales remains the operational parent/admissions system. This request does
not authorize CEFA to replace its inquiry flow, create records from BigQuery,
or change current school/program/day routing.

## Copy-Ready GreenRope Message

Subject: CEFA Parent inquiry identity and email-journey API requirements

Hello,

CEFA is strengthening the connection between our `cefa.ca` Gravity Forms
inquiries and GreenRope lifecycle reporting.

Please create two Short Text opportunity fields named exactly
`cefa_event_id` and `cefa_form_entry_id`, expose them through the opportunity
API for read/write, and confirm whether the current KinderTales inquiry API
creates or updates the related GreenRope contact/opportunity. We need that
existing path to save Form 4 field `32.4` as `cefa_event_id` and the saved
Gravity Forms entry ID as `cefa_form_entry_id`.

Please also provide the current API documentation and field dictionaries for
contacts, opportunities, phases, phase paths, CRM email activities, journeys,
and contact journey progress. We need stable IDs, event/status timestamps,
incremental filtering, pagination/rate limits, and available signed webhook
options. We do not need bulk raw parent or child PII.

Please confirm whether one contact can retain multiple separate opportunities
for different children, schools, programs, or start periods, and whether
GreenRope exposes any stable household/dependent relationship IDs.

We will run one controlled write/read-back after the fields and mapping are
ready. No existing assignment, workflow, stage, email, or opportunity behavior
should be changed.

Thank you.

## Copy-Ready KinderTales Message

Subject: CEFA inquiry identity and safe lifecycle API requirements

Hello,

CEFA currently submits Parent inquiries through CEFA School Manager to the
KinderTales public CRM inquiries endpoint. We want to strengthen identity and
measurement without changing current school, program, day, or inquiry routing.

Please confirm whether the existing inquiry endpoint accepts these additional
`metaData` values: `cefa_event_id`, `cefa_form_entry_id`, and
`cefa_attribution_schema_version`.

Please confirm which stable IDs are returned or can be looked up later for the
inquiry, parent/guardian, household/family, child/dependent, school, and
program. If the response does not return them synchronously, please describe a
lookup by `cefa_event_id`, incremental read API, export, or signed webhook.

For future read-only measurement, we need stable IDs and timestamped lifecycle
events such as inquiry received, contacted, tour scheduled/completed,
waitlisted, enrolled, and closed/lost. We do not need parent names, raw contact
details, child names, exact birth dates, addresses, or notes in the marketing
warehouse.

Please provide API authentication, timestamp, pagination, rate-limit,
idempotency, retry, merge/deletion, webhook-signing, and test-environment
documentation.

Thank you.

## Acceptance

The vendor portion is ready when:

1. GreenRope fields are visible through the API.
2. The KinderTales-to-GreenRope opportunity path and mapping are known.
3. One controlled Form 4 inquiry has matching event and entry IDs in
   GreenRope.
4. The same controlled inquiry still reaches KinderTales.
5. Any returned GreenRope/KinderTales IDs are written to restricted Gravity
   Forms entry metadata or the restricted identity bridge.
6. No duplicate opportunity or inquiry is created.
7. No current conversion, Mailchimp, school, program, day, or CRM workflow is
   changed.
