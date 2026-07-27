# CEFA System And Integration Register

**Last updated:** 2026-07-27
**Owner:** CEFA marketing operations
**Status:** Canonical cross-system register
**Review cadence:** Monthly and after every material integration change

## How To Read This Register

- `Flow status` describes whether the connection is currently verified.
- `Write state` describes whether CEFA is actively writing through the
  connection.
- `Failure effect` explains the business consequence, not only the technical
  symptom.
- Detailed fields, credentials and runtime code belong in the narrow owning
  contract or private runtime, not this public register.

## System Roles

| System ID | System | Primary role | Authority | Status |
|---|---|---|---|---|
| `SYS-WP-PARENT` | Parent WordPress `cefa.ca` | Parent acquisition site and Form 4 runtime | Website runtime | `Verified` |
| `SYS-WP-FCA` | Franchise Canada WordPress | Canada franchise forms and website events | Website runtime | `Verified` |
| `SYS-WP-FUS` | Franchise USA WordPress | USA franchise forms and website events | Website runtime | `Verified` |
| `SYS-GF` | Gravity Forms | Saved form submissions | Form evidence | `Verified` |
| `SYS-SM` | CEFA School Manager | Parent school/program/day behavior and KinderTales delivery | Parent operational integration | `Verified` |
| `SYS-KT` | KinderTales | Parent inquiry/admissions and final operational lifecycle source | Parent business destination | `Partial` API/identity coverage |
| `SYS-GR` | GreenRope | Parent CRM opportunity/lifecycle and email context | CRM context, not final enrollment truth | `Partial` |
| `SYS-SY` | Synuma/SiteZeus | Franchise lead delivery/routing | Franchise business destination | `Partial`; USA alert |
| `SYS-CT` | CEFA Conversion Tracking | Event identity, neutral events, attribution and guarded ledger | Website measurement bridge | `Verified`/`Active guarded` by property |
| `SYS-GAC` | GAConnector | Franchise attribution fields | Current franchise attribution owner | `Active guarded` pending cutover |
| `SYS-GTM` | Web GTM containers | Property-specific destination mapping | Browser tag routing | `Verified` current paths |
| `SYS-STAPE` | Stape Business | Planned server-side GTM transport | Additive server route | `Approved`; build pending |
| `SYS-GA4` | Three GA4 properties | Web behavior and event analytics | Analytics evidence | `Verified` with property-specific gaps |
| `SYS-GADS` | Google Ads accounts | Paid delivery and optimization | Platform delivery | `Verified` live; reporting freshness partial |
| `SYS-META` | Meta ad accounts/datasets | Paid delivery and optimization | Platform delivery | `Verified` live; reporting freshness partial |
| `SYS-BQ` | BigQuery | Reconciliation, marts, serving and activation ledger | Governed analytical layer | `Active guarded` |
| `SYS-DF` | Dataform | SQL dependency graph and assertions | Transformation/QA | `Active guarded`; production config pending |
| `SYS-CRUN` | Cloud Run and supporting GCP services | Extraction, webhooks, polling and dispatch | Private runtime | `Partial`; source-control gap |
| `SYS-SMTR` | Supermetrics | Connector-based reporting extracts | Supporting reporting source | `Partial` freshness |
| `SYS-LOOKER` | Looker Studio | Reader-facing dashboards | Serving consumer | `Partial` by contract/freshness |
| `SYS-GSC` | Google Search Console | Organic search performance | Organic source | `Partial` freshness |
| `SYS-DFS` | DataForSEO | Keyword/SERP research | Research source | `Partial` freshness |
| `SYS-GBP` | Google Business Profile | Local listing visibility and traffic | Local source | `Partial` crosswalk/UTMs |
| `SYS-YELP` | Yelp | Local listing visibility and traffic | Local source | `Partial` crosswalk/UTMs |
| `SYS-MC` | Mailchimp | Email audience and journey activity | Provider evidence | `Partial`; feed review pending |
| `SYS-ZOHO` | Gravity Forms Zoho surface | Possible parent CRM feed | Unknown until feed audit | `Open question` |
| `SYS-BUDGET` | OneDrive/SharePoint budget workbook | Approved budget plan | Budget source of truth | `Verified` source |
| `SYS-V21` | Paid-media v21 Google Sheet | Naming/copy/creative/build planning | Planning control | `Partial`; not launch authority |
| `SYS-N8N` | n8n | Future validation/export/audit automation | Guarded automation | `Pending` |
| `SYS-ASSET` | SharePoint/Drive creative sources | Creative files, versions, approvals and usage rights | Creative source | `Partial` |
| `SYS-PARTNER` | Partner and merchant placements | Offer/referral traffic such as merchant pages | External acquisition source | `Partial` |
| `SYS-SOCIAL` | Organic social publishing and analytics | Organic social content and referral traffic | Channel source | `Open question` |
| `SYS-CALENDAR` | Campaign brief/calendar/postmortem register | Cross-channel plan, owner, hypothesis and learning history | Operating control | `Pending` |
| `SYS-GITHUB-PUB` | `cefa-marketing-ops` | Public context, plugin and safe QA source | Public governance | `Verified` |
| `SYS-GITHUB-PRIV` | Planned CEFA private runtime repo | Deployable Cloud/Stape/Dataform source | Private production source | `Blocked` |

## Parent Integrations

| Integration ID | Source -> destination | Purpose and identity | Flow status | Write state | Failure effect | Owner / evidence |
|---|---|---|---|---|---|---|
| `INT-P-001` | Parent WordPress -> Gravity Forms Form 4 | Save one inquiry entry | `Verified` | Live | No saved inquiry/business record | Conversion tracking and School Manager |
| `INT-P-002` | School Manager -> Form 4 | Populate school/program/day and journey context using `school_uuid` | `Verified` | Live | Wrong routing or incomplete business fields | [Form 4 boundary](../10-conversion-tracking/parent-form4-kindertales-attribution-boundary-2026-07-10.md) |
| `INT-P-003` | Form 4/School Manager -> KinderTales | Deliver parent inquiry | `Verified` current path | Live | Saved form may not reach admissions | School Manager/KinderTales owner |
| `INT-P-004` | CEFA Conversion Tracking -> Form 4 | Event identity and canonical attribution fields | `Verified`/guarded | Live parent configuration | Attribution gaps; should not block KinderTales | [Plugin README](../../README.md) |
| `INT-P-005` | Confirmed Form 4 -> dataLayer | Emit `school_inquiry_submit` once with event identity | `Verified` | Live | Platforms become blind or duplicate if ownership conflicts | [Event matrix](../10-conversion-tracking/event-ownership-matrix-2026-05-05.md) |
| `INT-P-006` | Parent dataLayer -> GTM -> GA4/Google/Meta | Map neutral inquiry event to destinations | `Verified` current path | Live | Platform reporting/optimization mismatch | Conversion tracking owner |
| `INT-P-007` | Form 4 -> Mailchimp | Existing Gravity Forms feed | `Partial`; field/purpose review pending | Possibly live | Audience or field handling may be misunderstood | [Plugin inventory](../10-conversion-tracking/live-wordpress-tracking-plugin-inventory-2026-07-27.md) |
| `INT-P-008` | Form 4 -> Zoho CRM | Possible Gravity Forms feed | `Open question` | Unknown | Operators may assume a CRM path that is not active | Feed audit required |
| `INT-P-009` | Form 4 -> parent webhooks | Possible external feeds | `Open question` | Unknown | Hidden duplicate or undocumented delivery path | Feed audit required |
| `INT-P-010` | KinderTales -> GreenRope | Create/update related contact/opportunity | `Open question`; vendor confirmation required | Unknown | Offline lifecycle cannot be joined safely | [Vendor request](../10-conversion-tracking/parent-omnichannel-vendor-api-request-2026-07-25.md) |
| `INT-P-011` | GreenRope -> BigQuery lifecycle ledger | Observe prospective stage changes | `Active guarded`; exact identity blocked | Baseline/poller foundation, sending gated | Outcomes quarantined or misjoined without exact identity | [Offline implementation](../10-conversion-tracking/parent-crm-offline-conversion-implementation-report.md) |
| `INT-P-012` | Lifecycle outbox -> Google/Meta | Send secondary CRM stage conversions | `Active guarded` | Production sending disabled/gated | Platforms remain blind to downstream quality | Parent CRM activation contract |

## Franchise Integrations

| Integration ID | Source -> destination | Purpose and identity | Flow status | Write state | Failure effect | Owner / evidence |
|---|---|---|---|---|---|---|
| `INT-F-001` | Franchise Canada forms -> Synuma | Deliver Form 1/2 business records | `Partial` | Live | Saved lead may not reach franchise CRM | Franchise delivery owner |
| `INT-F-002` | Franchise USA forms -> Synuma | Deliver Form 1/2 business records | `Alert`; recent ID gaps | Live | Platform lead may lack confirmed CRM delivery | [Shadow rollout](../10-conversion-tracking/franchise-gaconnector-shadow-rollout-2026-07-20.md) |
| `INT-F-003` | GAConnector -> franchise hidden fields | Preserve first/last-touch attribution | `Active guarded` current owner | Live | Attribution fields become incomplete if removed early | GAConnector shadow contract |
| `INT-F-004` | CEFA Conversion Tracking -> franchise entry meta | Shadow canonical attribution and parity evidence | `Active guarded` | Shadow only | No cutover evidence if capture fails | [Shadow rollout](../10-conversion-tracking/franchise-gaconnector-shadow-rollout-2026-07-20.md) |
| `INT-F-005` | Franchise WPCode bridge -> dataLayer | Emit confirmed neutral Form 1/2 events | `Verified` current bridge | Live | Final platform events may fail or duplicate | Conversion tracking owner |
| `INT-F-006` | Franchise dataLayer -> property GTM -> platforms | Route GA4/Google/Meta destinations | `Verified`/`Partial` by destination | Live | Cross-property or wrong-goal reporting | Event ownership matrix |

## Data, Reporting And Activation Integrations

| Integration ID | Source -> destination | Purpose and identity | Flow status | Write state | Failure effect | Owner / evidence |
|---|---|---|---|---|---|---|
| `INT-D-001` | GA4 parent -> BigQuery export | Event-level analytics export | `Verified` | Live native export | Web analytics marts become stale | BigQuery owner |
| `INT-D-002` | Google/Meta -> BigQuery/Supermetrics | Spend, object and conversion detail | `Partial` freshness | Live/connector schedules vary | Dashboard can show stale paid detail | [Platform availability](../50-paid-media/platform-data-availability-2026-05-03.md) |
| `INT-D-003` | Raw BigQuery -> Dataform/core/marts | Governed transforms and assertions | `Active guarded` | Partial production path | Metrics drift or lack reproducibility | [Dataform parity](../20-bigquery/dataform-source-control-and-parity-2026-07-25.md) |
| `INT-D-004` | BigQuery serving -> Looker Studio | Reader-facing reporting | `Partial` by dashboard contract | Live selected views | Dashboard can disagree with source/grain | BigQuery/dashboard owner |
| `INT-D-005` | Websites/GTM -> Stape -> destinations | First-party server transport and deduplication | `Approved`; not built | Off | Browser loss remains; bad rollout could duplicate | Cloud/Stape blueprint |
| `INT-D-006` | Cloud services -> monitoring/alerts | Delivery, freshness, failure and cost health | `Partial` | Partial | Silent failures or delayed diagnosis | Cloud runtime owner |
| `INT-D-007` | Public hub -> private runtime repo | Governance to reproducible deployment source | `Blocked` | Not established | Runtime remains dependent on private local/historical artifacts | Program register |

## SEO, Local And Campaign Operations Integrations

| Integration ID | Source -> destination | Purpose and identity | Flow status | Write state | Failure effect | Owner / evidence |
|---|---|---|---|---|---|---|
| `INT-S-001` | Search Console -> SEO analysis/warehouse | Query/page organic performance | `Partial` freshness | Read-only | Organic decisions rely on stale period | [SEO handoff](../30-seo/seo-restart-handoff-2026-05-03.md) |
| `INT-S-002` | DataForSEO -> research | Keyword, SERP and market research | `Partial` freshness | Read-only | Research may not reflect current market | SEO owner |
| `INT-S-003` | GBP/Yelp -> CEFA pages | Local traffic with `ll1` UTMs | `Partial` crosswalk/field availability | Some links may be live | School attribution is inconsistent | Local listing rules |
| `INT-O-001` | Budget workbook -> planning | Approved monthly/group budget context | `Verified` source | Read-only into planning | Campaign plans use wrong budget | Budget owner |
| `INT-O-002` | v21 sheet -> build/import output | Trace copy, creative, URL and object destinations | `Partial` | Draft/paused outputs only | Import rows can target wrong objects | Naming/build control owner |
| `INT-O-003` | v21/naming -> n8n | Validate/export/audit builds | `Pending` | No autonomous production writes | Manual effort remains; unsafe writes if scope expands | Naming/automation owner |
| `INT-O-004` | Mailchimp/GreenRope engagement -> BigQuery | Later omnichannel journey evidence | `Pending later phase` | Off | No unified email/lifecycle visibility | Growth operations/data owner |
| `INT-O-005` | SharePoint/Drive creative source -> v21/build process | Carry approved asset, version and usage evidence into builds | `Partial` | Manual | Wrong or unapproved creative can be launched | Creative/marketing owner |
| `INT-O-006` | Partner/merchant placement -> CEFA URL | Carry governed offer and partner attribution into the website | `Partial` | Live per initiative | Partner demand becomes untraceable or offer terms drift | Partnerships/marketing owner |
| `INT-O-007` | Campaign brief/calendar -> platform build/postmortem | Preserve owner, objective, audience, budget, hypothesis and result | `Pending` | No central contract | Repeated tests and unclear accountability | Marketing operations owner |
| `INT-O-008` | Organic social -> CEFA website/GA4 | Carry governed source/content attribution | `Open question` | Platform activity exists; contract not registered | Organic social impact cannot be reconciled | Content/social owner |

## Change Procedure

1. Verify the live source and destination read-only.
2. Identify the integration ID.
3. Update the narrow owning contract.
4. Update this row if flow status, write state, identity, owner or failure
   effect changed.
5. Update the program register if a blocker, production gate or sequence
   changed.
6. Update the machine-readable context manifest.
7. Record tests, read-back and rollback.

Never infer that an integration is live merely because a plugin, account or
API credential exists.
