# Parent KinderTales Identity WordPress Rollout

**Date:** 2026-07-25
**Status:** Code deployed; identity delivery disabled pending vendor approval
**Scope:** Parent `cefa.ca` Form 4 only

## Outcome

CEFA School Manager `1.0.22` is deployed to staging and production. It can add
these identity-only values to the existing KinderTales `metaData`:

- `cefa_event_id`;
- `cefa_form_entry_id`;
- `cefa_attribution_schema_version`.

The production feature flag is absent, so no live inquiry currently sends the
new values. Existing KinderTales payloads, Form 4 fields `35-46`, attribution
writeback, Gravity Forms confirmation behavior, and Google/Meta/GA4
conversions remain unchanged.

## Implementation

The existing CEFA School Manager remains the only KinderTales sender. The
change:

1. reads the event ID from the School Inquiry compound field input `.4`;
2. reads the saved Gravity Forms entry ID after submission;
3. validates both identifiers;
4. adds the three metadata values only when
   `CEFA_SM_KT_IDENTITY_METADATA_ENABLED` is true;
5. returns no additional metadata when disabled or when identity is invalid;
6. never blocks the existing KinderTales inquiry request.

No browser JavaScript, new hidden fields, second API request, GTM event, GA4
event, Google Ads conversion, Meta event, GreenRope write, or KinderTales
routing change was introduced.

The exact source patch is
[`snippets/cefa-school-manager-1.0.22-kindertales-identity.patch`](../../snippets/cefa-school-manager-1.0.22-kindertales-identity.patch).

## Deployment And QA

| Check | Result |
|---|---|
| Production baseline | CEFA homepage HTTP `200` before deployment |
| Staging and production source baseline | Identical School Manager `1.0.21` files |
| PHP lint | Passed locally, staging, and production |
| Identity helper tests | Passed locally and on staging |
| Disabled production no-send | Existing tracking keys and waitlist shape intact; no identity keys |
| Enabled-in-memory production no-send | Exactly three identity keys added with matching synthetic values |
| External delivery during QA | Blocked through `pre_http_request`; zero KinderTales requests |
| Gravity Forms entries during QA | None created |
| Production plugin state | School Manager `1.0.22`, active |
| Production feature flag | Absent/disabled |
| Conversion plugin read-back | CEFA Conversion Tracking `0.6.3`, active |
| Production post-deploy homepage | HTTP `200` |
| Temporary QA files | Removed from staging and production |

The staging site has a separate pre-existing theme dependency failure: its
theme Composer platform check requires PHP `>=8.4` while staging runs PHP
`8.2.31`. This prevented browser end-to-end staging QA but did not affect
plugin source lint or isolated server-side tests.

## Activation Gate

Do not enable production delivery until the KinderTales/GreenRope team
confirms:

1. the KinderTales endpoint accepts the three keys;
2. extra metadata does not change validation, routing, or workflows;
3. the values are retained or mapped to GreenRope;
4. the GreenRope opportunity fields exist;
5. CEFA can retrieve the values from lifecycle webhook `opportunityID`, or
   receive them in the webhook directly.

The vendor-ready email is
[KinderTales and GreenRope identity/webhook vendor email](./kindertales-greenrope-identity-webhook-email-2026-07-25.md).

## Activation Procedure

After written vendor confirmation:

1. confirm the GreenRope field dictionary;
2. enable `CEFA_SM_KT_IDENTITY_METADATA_ENABLED` in staging or a vendor test
   environment;
3. set `CEFA_SM_KT_ATTRIBUTION_SCHEMA_VERSION` to `1.0`;
4. submit one controlled Form 4 inquiry;
5. confirm one Gravity Forms entry and one successful KinderTales note;
6. confirm matching IDs in KinderTales and GreenRope;
7. confirm existing website conversions fire once;
8. enable production;
9. inspect the first natural production inquiry;
10. disable the flag immediately on any validation, routing, duplication,
    attribution, or conversion regression.

## Rollback

Immediate behavioral rollback is to remove or set
`CEFA_SM_KT_IDENTITY_METADATA_ENABLED` to false. This restores the original
payload without changing the plugin files.

Full code rollback restores School Manager `1.0.21`, removes
`includes/kindertales-identity-metadata.php`, and restores the prior
`class-gf-addon.php`. The exact original production file hashes and local
rollback copies were retained during deployment; no secrets or payloads are
stored in GitHub.
