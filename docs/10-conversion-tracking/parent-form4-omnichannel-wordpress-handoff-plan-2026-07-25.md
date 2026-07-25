# Parent Form 4 Omnichannel WordPress Handoff Plan

**Date:** 2026-07-25
**Status:** Canonical implementation contract; no live mutation in this update
**Scope:** `cefa.ca`, Gravity Forms Form `4`, CEFA Conversion Tracking,
CEFA School Manager, KinderTales, GreenRope, and Mailchimp
**Canonical plan:** [Google Cloud and Stape measurement platform
blueprint](../superpowers/plans/2026-07-25-google-cloud-stape-measurement-platform-blueprint.md)

## Decision

Do not solve the omnichannel identity requirement by adding a large collection
of browser-visible hidden fields.

Use:

1. existing Form 4 business and attribution fields;
2. server-generated Gravity Forms entry metadata;
3. a versioned server-side handoff envelope;
4. an isolated, idempotent outbox/worker outside the KinderTales critical
   delivery path;
5. hidden fields only when a verified existing vendor mapper cannot consume
   server-side metadata or payload values.

This protects current conversions and avoids exposing CRM IDs, household IDs,
child IDs, or internal identity keys in page HTML.

## Read-Only Live Findings

Verified against production Form `4` on 2026-07-25:

- the highest currently observed field ID is `56`;
- IDs `47-56` are already occupied;
- field `32.4` is the existing event ID;
- fields `35-46` are the current UTM/click/landing/referrer contract;
- field `49` is Requested Start Date;
- the active Mailchimp feed is feed `3`;
- the active CEFA Dashboard Parent Inquiry Handoff webhook is feed `4`;
- no GreenRope writer exists in CEFA Conversion Tracking or CEFA School
  Manager according to the current repository/live-plugin review.

Do not assume that `57` or any later numeric ID is available. Export the live
form immediately before an approved form revision, create fields through
Gravity Forms, and then register the actual assigned IDs.

## Existing Field Contract To Preserve

| Field | Purpose |
|---|---|
| `32.1` | KinderTales/CEFA school UUID |
| `32.2` | Selected program ID |
| `32.3` | Selected days |
| `32.4` | `cefa_event_id` |
| `32.5` | School slug |
| `32.6` | School name |
| `32.7` | Program name |
| `35-44` | Canonical UTM and click-ID compatibility fields |
| `45-46` | First landing page and referrer |
| `49` | Requested start date |

CEFA School Manager continues to own field `32`, school/program/day
resolution, and KinderTales delivery. CEFA Conversion Tracking continues to
own event identity and attribution only.

## Server-Side Handoff Envelope

Build the following envelope after the Gravity Forms entry has saved:

### Identity

- `cefa_event_id`: exact field `32.4`;
- `cefa_form_entry_id`: saved Gravity Forms entry ID;
- `site_context`: `parent_ca`;
- `form_id`: `4`;
- `form_family`: `parent_inquiry`;
- `identity_schema_version`;
- `attribution_schema_version`;
- test-submission flag.

### School and inquiry context

- `school_uuid`: field `32.1`;
- school slug: field `32.5`;
- program ID: field `32.2`;
- program name: field `32.7`;
- selected days: field `32.3`;
- requested start date: field `49`;
- approved derived program/age eligibility band where needed.

Do not put child name, exact birth date, gender, address, comments, or other
child fields in the marketing handoff. Existing operational KinderTales
delivery remains separate.

### Attribution

Read the verified signed attribution envelope already saved by CEFA Conversion
Tracking:

- first source, medium, campaign, campaign ID, content, term, landing,
  referrer, and timestamp;
- last-non-direct source, medium, campaign, campaign ID, content, term,
  landing, referrer, and timestamp;
- valid `gclid`, `gbraid`, `wbraid`, `fbclid`, and `msclkid`;
- approved platform campaign/ad group/ad/ad-set IDs;
- GA client and session IDs;
- `fbp` and `fbc` only when genuinely captured;
- agency/test marker;
- touch count and schema/provenance.

Do not send arbitrary query strings or the complete touch-history JSON to CRM.

## Gravity Forms Entry Metadata

Persist operational handoff state as server-side entry metadata:

- `cefa_crm_handoff_schema_version`;
- `cefa_crm_handoff_status`;
- `cefa_crm_handoff_attempted_at`;
- `cefa_crm_handoff_completed_at`;
- `cefa_greenrope_contact_id`;
- `cefa_greenrope_opportunity_id`;
- `cefa_kindertales_inquiry_id`;
- `cefa_kindertales_parent_id`, if returned;
- `cefa_kindertales_household_id`, if returned;
- `cefa_kindertales_child_id`, if returned;
- last error category and retry state without raw payload or PII.

Source IDs may remain in the operational Gravity Forms entry under restricted
WordPress access. Normal marketing BigQuery tables receive only HMAC-derived
keys and safe relationship facts.

## Delivery Design

### KinderTales

Keep the current path unchanged:

```text
Form 4 -> CEFA School Manager -> KinderTales
```

After KinderTales confirms the metadata contract:

- add `cefa_event_id`, `cefa_form_entry_id`, and schema version to School
  Manager's existing `metaData`;
- preserve current fields `32.*` and `35-46`;
- capture the returned inquiry/source IDs in Gravity Forms entry metadata;
- do not add a second KinderTales request from CEFA Conversion Tracking;
- do not make Google Cloud, Stape, GreenRope, or BigQuery a prerequisite for
  KinderTales success.

### GreenRope

Do not add a second opportunity-creation writer until the owner of the current
GreenRope creation path is identified.

Preferred order:

1. The current GreenRope creation integration maps `cefa_event_id` and
   `cefa_form_entry_id` at creation.
2. If that integration cannot be changed, use the existing CEFA Parent Form 4
   restricted capture plus an idempotent Cloud Run create/update handoff.
3. Use `cefa_event_id` as the destination idempotency/resolution key.
4. Write returned GreenRope contact/opportunity IDs to restricted entry
   metadata.
5. Retry asynchronously and never block the form confirmation or KinderTales
   delivery.

The GreenRope payload may use existing GreenRope UTM/click fields when their
semantics match. Create new CRM fields only for missing governed values rather
than creating duplicate UTM definitions.

### Mailchimp

The current active Gravity Forms Mailchimp feed maps:

- parent email;
- address;
- exact child date of birth into Mailchimp `BIRTHDAY`;
- parent first and last name;
- phone;
- tags.

The checked feed metadata did not show a configured opt-in condition. This is
a read-only finding, not a live change.

Before the omnichannel email phase:

1. Export and back up the current feed.
2. Confirm its actual audience, business purpose, tags, subscription behavior,
   and downstream journeys.
3. Remove exact child DOB, address, and phone unless CEFA documents a required
   use for each field.
4. Prefer parent email plus the minimum approved parent name context.
5. Use explicit CEFA school/program identifiers, merge fields, or governed
   tags instead of campaign-name guessing.
6. Configure Mailchimp API/webhook ingestion for subscription, bounce,
   unsubscribe, complaint, campaign, click, and journey activity.
7. Tokenize contact identity before BigQuery.
8. Keep opens as low-confidence diagnostics.
9. Do not create another website conversion or resend `Inquiry Submit` from
   the email integration.

Recipient eligibility/opt-in mapping must be confirmed before any new
Mailchimp audience or journey write. This is a narrow promotion gate, not a
request to redesign the wider consent program in this phase.

## Hidden-Field Fallback

Only if a verified vendor integration cannot consume the server-side handoff,
create Gravity Forms hidden fields for the minimum missing values:

- first source, medium, campaign, campaign ID, and first-touch timestamp;
- last-non-direct source, medium, campaign, campaign ID, and touch timestamp;
- attribution schema version;
- GA client/session ID, `fbp`, and `fbc` only when the destination contract
  requires them.

Rules:

- obtain actual numeric IDs from a controlled Gravity Forms revision;
- register them in `class-cefa-conversion-tracking-config.php` and a versioned
  field-map document;
- populate them server-side from the verified signed envelope;
- never create a hidden `cefa_form_entry_id` before submission;
- never expose GreenRope, KinderTales, parent, household, or child source IDs
  in hidden fields;
- never use a browser-supplied hidden value as authoritative identity.

## Plugin Responsibility Split

| Component | Responsibility |
|---|---|
| CEFA Conversion Tracking | Attribution envelope, event identity, canonical entry evidence |
| CEFA School Manager | Field `32`, school/program/day behavior, KinderTales payload |
| Parent CRM handoff worker | GreenRope identity update/create, outbox, retries, returned source IDs |
| Cloud Run/BigQuery | Tokenization, identity bridge, lifecycle and email ingestion, reporting/activation |
| Mailchimp/GreenRope | Email and journey delivery truth |

If WordPress code is required for the GreenRope handoff, implement it as a
separate narrow Parent CRM bridge module/plugin or a signed handoff adapter.
Do not turn CEFA Conversion Tracking into the GreenRope or KinderTales
business-delivery owner.

## Rollout Order

1. Export Form 4, active feeds, CEFA School Manager, and CEFA Conversion
   Tracking baselines.
2. Receive GreenRope and KinderTales API answers.
3. Confirm the current GreenRope opportunity-creation owner.
4. Create destination fields and mapping in non-production/test mode.
5. Implement the server handoff and entry metadata behind a disabled flag.
6. Run PHP/unit tests for envelope validation, sanitization, idempotency, and
   PII blocking.
7. Run one controlled Form 4 submission.
8. Confirm one Gravity entry, one KinderTales inquiry, one GreenRope
   opportunity, and one existing website conversion.
9. Confirm source IDs are written back and no CRM/source ID appears in HTML,
   dataLayer, GA4, Google Ads, Meta, Stape logs, or normal BigQuery tables.
10. Enable the identity handoff independently from later Mailchimp/GreenRope
    email ingestion.
11. Add email/journey ingestion read-only.
12. Consider outbound email/audience writes only under a separate approval.

## Acceptance Tests

- Form `4` field `32` behavior is unchanged.
- Fields `35-46` retain current semantics.
- KinderTales success/failure behavior is unchanged.
- `school_inquiry_submit` fires exactly once.
- Google and Meta website conversions remain unchanged.
- GreenRope receives matching event and entry IDs.
- No duplicate opportunity is created on retry.
- Returned source IDs are server-side only.
- Multiple inquiries from one parent remain separate.
- Multiple children in one household are not collapsed.
- Mailchimp provider totals reconcile before journey attribution is promoted.
- No exact child DOB, address, or raw child identity enters marketing
  BigQuery.
