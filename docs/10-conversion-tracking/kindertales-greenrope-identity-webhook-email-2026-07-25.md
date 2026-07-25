# KinderTales And GreenRope Identity/Webhook Vendor Email

**Date:** 2026-07-25
**Status:** Ready to send
**Scope:** CEFA Parent inquiries from `cefa.ca`

## Email

**Subject:** CEFA Parent inquiry identity and GreenRope lifecycle webhook
requirements

Hello,

CEFA is strengthening the measurement connection between our `cefa.ca`
Parent inquiry form, KinderTales, and GreenRope. We are not replacing the
current inquiry flow, changing school/program routing, or changing existing
GreenRope workflows.

Our confirmed current flow is:

```text
Gravity Forms Form 4
  -> CEFA School Manager WordPress plugin
  -> KinderTales public CRM inquiry API
  -> related GreenRope contact/opportunity and lifecycle workflows
```

We also see GreenRope workflows posting opportunity stage information to an
existing AWS endpoint, including `opportunityID`, `opportunityPhaseID`,
`accountID`, and `reason`. We want to preserve that integration exactly as it
is and understand whether CEFA can add a separate measurement webhook
alongside it.

Could you please answer the following?

### 1. KinderTales-to-GreenRope relationship

1. Does each successful KinderTales inquiry API submission create or update a
   GreenRope contact and opportunity?
2. Is that link synchronous or created later by a background integration?
3. Can one parent/contact retain separate inquiries or opportunities for
   multiple children, schools, programs, or requested start periods?
4. Which stable KinderTales and GreenRope identifiers link the inquiry,
   contact, opportunity, household/family, child, school, and program?

**Why we are asking:** We need to connect one website inquiry to the correct
later opportunity outcome without collapsing repeat inquiries or families
with more than one child.

### 2. CEFA identity metadata

CEFA proposes adding these values to the existing KinderTales inquiry
`metaData`:

- `cefa_event_id`: CEFA's unique website submission event ID;
- `cefa_form_entry_id`: the saved Gravity Forms Form 4 entry ID;
- `cefa_attribution_schema_version`: the version of the attribution contract.

5. Does the KinderTales endpoint accept these additional metadata keys without
   changing current routing, validation, or workflow behavior?
6. Can these values be copied to the related GreenRope opportunity?
7. Please create GreenRope Short Text opportunity fields named exactly
   `cefa_event_id` and `cefa_form_entry_id`. What are their API field names?
8. Can the KinderTales API response return a stable inquiry ID and the related
   GreenRope `contact_id` and `opportunity_id`?
9. If the GreenRope IDs are created asynchronously, can CEFA retrieve them
   later by `cefa_event_id`?
10. How are duplicate KinderTales inquiries, GreenRope contacts, and GreenRope
    opportunities prevented when the same `cefa_event_id` is retried?

**Why we are asking:** These values let CEFA match the form, KinderTales
inquiry, GreenRope opportunity, and later lifecycle event exactly. They do not
contain parent or child personal information.

### 3. Additional CEFA lifecycle webhook

11. Can GreenRope send the same opportunity events to an additional
    CEFA-owned webhook without modifying or disabling the existing AWS
    webhook?
12. Can the additional webhook be limited to the approved CEFA Parent groups
    or phase paths?
13. Can it fire for:
    - opportunity created;
    - phase/stage changed;
    - tour scheduled;
    - tour completed or post-tour;
    - enrollment/closed won;
    - closed lost;
    - opportunity reassigned, merged, corrected, or deleted?
14. Can the webhook include:
    - a stable webhook event/delivery ID;
    - `opportunityID`;
    - `contactID`, when permitted;
    - previous and new phase IDs;
    - reason/status;
    - the actual transition timestamp in UTC;
    - `cefa_event_id`;
    - `cefa_form_entry_id`;
    - group/location ID?
15. If custom fields cannot be included, can CEFA use `opportunityID` to read
    the opportunity and its custom fields through the GreenRope API?
16. Does GreenRope support HMAC signatures or another verifiable webhook
    signature?
17. What are the retry schedule, timeout, duplicate-delivery behavior, and
    expected success response?
18. Is there a webhook test mode, test opportunity, or non-production group we
    can use before enabling production delivery?

**Why we are asking:** The webhook would let CEFA observe later CRM outcomes
promptly for reporting and secondary Google/Meta offline conversion signals.
It would not update GreenRope or replace the operational AWS integration.

### 4. API and lifecycle contract

19. Please confirm the supported endpoints, permissions, pagination, rate
    limits, UTC timestamp definitions, and incremental filters for:
    - opportunity fields;
    - opportunities by ID and by modified date;
    - phases and phase paths;
    - contacts by stable ID;
    - CRM email activity;
    - customer journeys and journey progress;
    - delivery, click, bounce, unsubscribe, and complaint activity.
20. How are contact merges, opportunity merges, reassignment, corrections, and
    deletions represented in the API?
21. Can CEFA receive stable IDs, relationship edges, statuses, and timestamps
    without exporting raw parent names, child names, exact birth dates,
    addresses, notes, or other unnecessary personal information?

**Why we are asking:** This supports a privacy-minimized reporting and
activation layer while keeping KinderTales/GreenRope as the operational
systems of record.

Our preferred outcome is:

1. CEFA sends the three identity metadata values in the existing KinderTales
   inquiry request.
2. KinderTales preserves them on the related GreenRope opportunity.
3. GreenRope sends a separate signed lifecycle webhook to CEFA.
4. The webhook includes the CEFA IDs, or CEFA retrieves them by
   `opportunityID`.
5. The existing KinderTales routing, GreenRope workflows, AWS webhook, and
   website conversions remain unchanged.

We can provide one controlled test submission after the field and webhook
contracts are confirmed.

Thank you.

## Internal Sending Note

Send this to the team that owns both the KinderTales inquiry API and the
GreenRope opportunity/workflow configuration. Attach or reference the exact
current webhook only through the vendor's approved support channel. Do not
include API credentials, WordPress secrets, raw inquiry payloads, or personal
information.
