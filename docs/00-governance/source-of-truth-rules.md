# Source Of Truth Rules

**Last updated:** 2026-07-27
**Status:** Governing repository contract

## Authority Order

Use this order when sources conflict:

1. Verified live systems and current read-back evidence.
2. Runtime code and the current narrow implementation contract.
3. [Measurement platform handover](./measurement-platform-handover-2026-07-27.md)
   and [program register](./measurement-and-activation-program-register-2026-07-23.md)
   for cross-workstream ownership, status, blockers, and sequencing.
4. [Google Cloud and Stape implementation blueprint](../superpowers/plans/2026-07-25-google-cloud-stape-measurement-platform-blueprint.md).
5. [Locked BigQuery strategic blueprint](../superpowers/plans/2026-06-12-bq-marketing-intelligence-blueprint.md).
6. Dated implementation reports and historical phase documents.
7. Private CEFA source evidence explicitly cited by a current document.
8. External platform guidance and best practices.

If evidence is not current, mark it `Partial`, `Pending`, `Blocked`, or
`Open question`. Do not upgrade an assumption to `Verified`.

## Plan Hierarchy

The June and July plans are complementary:

- June 12: locked strategic direction for the warehouse, semantic layer,
  intelligence, activation, predictive work, and stable dashboard boundary.
- July 25: definitive implementation architecture for Google Cloud, BigQuery,
  Dataform, Stape, identity, activation, security, and phased delivery.
- Program register: current operational truth for what is live, approved,
  blocked, pending, or next.

The program register may update current state without rewriting the strategic
or architectural plans. A replacement strategy requires explicit CEFA
approval.

## Stable Current Decisions

| Decision | Current source |
|---|---|
| Parent canonical submit event is `school_inquiry_submit` | Plugin and conversion-tracking contract |
| Parent inquiry business truth starts with Gravity Forms Form 4 | Handover and Form 4 boundary |
| CEFA School Manager owns parent business fields and KinderTales delivery | Form 4/KinderTales boundary |
| Parent school join key is `school_uuid` | Data taxonomy and master data |
| Parent event identity is `cefa_event_id` / Form 4 field `32.4` | Plugin and identity contract |
| Parent attribution fields are `35-46` | Plugin and Form 4 boundary |
| Franchise business truth is Gravity Forms plus Synuma/SiteZeus delivery | Franchise tracking contracts |
| GAConnector remains franchise attribution owner until cutover approval | Franchise shadow rollout |
| Parent, Franchise Canada and Franchise USA remain isolated | Handover and cross-property boundaries |
| Website events stay neutral; GTM/sGTM maps destinations | Event ownership contracts |
| Browser/server copies of one event use the same identity | Cloud/Stape blueprint |
| Website inquiry conversions remain primary | Program register |
| CRM-stage conversions launch secondary/reporting-only | Parent CRM activation blueprint |
| `school_uuid` remains the canonical parent school join | Master data and cloud blueprint |
| Meta NC1 remains the live naming baseline | Paid-media naming standard |
| NC2 and GADS1 remain planning candidates | Paid-media naming standard |
| Visible parent/enrollment copy uses CEFA Early Years language | Paid-media naming standard |
| BigQuery is not a second CRM and normal marts contain no raw parent/child PII | Cloud/Stape blueprint |
| Existing dashboard contracts change only after reconciliation and approval | BigQuery strategic blueprint |

## Business Truth Versus Reporting

| Question | Primary truth | Supporting evidence |
|---|---|---|
| Did a parent inquiry happen? | Saved Form 4 entry and KinderTales delivery status | Website event, GA4, Google, Meta, BigQuery |
| Did a franchise inquiry happen? | Saved franchise form entry and Synuma delivery | Website event, GA4, Google, Meta, BigQuery |
| Which school was selected? | Form 4 `school_uuid` / Field `32.1` | `dim_school`, event payload |
| Which ad object delivered traffic? | Platform object ID and valid click/UTM evidence | Naming key and warehouse joins |
| Did a CRM stage happen? | Prospective GreenRope transition after baseline | Lifecycle ledger and platform delivery |
| What should a dashboard show? | Certified BigQuery serving contract | Source freshness, reconciliation and governance |

Platform conversion counts are not business truth by themselves.

## Public Repository Boundary

This repository is public.

Allowed:

- non-secret plugin code;
- redacted plans and contracts;
- event, naming and schema definitions;
- aggregate QA and status;
- public-safe examples.

Prohibited:

- secrets, credentials and authentication files;
- raw CRM/form/platform payloads;
- parent, child, lead, employee or vendor PII;
- private browser sessions or full exports;
- private production runtime intended for CEFA-only source control.

Private Cloud Run, Dataform, infrastructure, Stape, GTM and deployment runtime
must move into the CEFA-controlled private runtime repository described by the
Cloud/Stape blueprint.

## Verification Labels

| Label | Meaning |
|---|---|
| `Verified` | Confirmed by current live evidence, code, API, BigQuery or cited source |
| `Active guarded` | Built or live under explicit safety gates |
| `Approved` | Direction or tooling approved; implementation may remain pending |
| `Partial` | Available but incomplete, stale, source-limited or unreconciled |
| `Pending` | Required work or input is known but not completed |
| `Blocked` | A named dependency prevents the next gate |
| `Open question` | Requires owner/vendor/platform confirmation |
| `Reference only` | Historical or supporting context, not current authority |

## Cross-Workstream Update Rule

1. Update the narrow owning implementation document.
2. Update its workstream README.
3. Update the program register if status, blocker, ownership, platform
   destination, production gate, or sequence changed.
4. Update the data taxonomy if a source, identifier, event, or data-layer
   relationship changed.
5. Update this file only when the authority order or stable operating rules
   change.
6. Update the handover when a new owner would otherwise misunderstand the
   system.
