# Repository Rename Decision

**Decision date:** 2026-07-27
**Status:** Approved and implemented

## Decision

Rename the public GitHub repository:

```text
mert-atalay/conversion_tracking
```

to:

```text
mert-atalay/cefa-marketing-ops
```

The default branch remains `main`.

## Reason

The repository is no longer only a conversion-tracking plugin repository. It
is the governed public hub for:

- conversion tracking and attribution;
- BigQuery, Google Cloud and Dataform;
- Stape and server-side GTM;
- paid-media setup, QA and optimization context;
- SEO and local-search measurement;
- naming conventions, UTMs and creative/build contracts;
- school, program and platform master data;
- CRM lifecycle and offline conversion activation;
- public plugin/runtime code, tests and non-secret QA packages;
- the current implementation roadmap, gaps and handover.

`cefa-marketing-ops` describes that scope without implying that this public
repository contains private customer data or all production runtime.

## Names That Do Not Change

The rename does not change:

- the `CEFA Conversion Tracking` WordPress plugin name;
- the Composer package `cefa/conversion-tracking`;
- plugin classes, constants, database keys or event names;
- `docs/10-conversion-tracking/`;
- live platform objects, campaigns, conversions, GTM, GA4 or CRM behavior.

## Compatibility

- GitHub redirects the former repository URL to the new URL.
- New clone instructions and plugin update metadata use
  `mert-atalay/cefa-marketing-ops`.
- Historical local folders may retain the name `conversion_tracking`; a local
  folder name is not repository authority.
- Historical documents may mention the former name when describing evidence
  captured before the rename.

## Boundary

The renamed repository remains public. Private Cloud Run, Dataform,
infrastructure, credentials, raw payloads, PII and restricted identity data
still require the separate CEFA-controlled private runtime repository defined
in the handover and program register.
