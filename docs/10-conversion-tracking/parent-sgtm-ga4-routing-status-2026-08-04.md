# Parent GA4, sGTM And Certified Reporting Status

**Date:** 2026-08-04; updated 2026-08-05
**Scope:** Parent `cefa.ca` only  
**Canonical program:** [Measurement and activation program register](../00-governance/measurement-and-activation-program-register-2026-07-23.md)  
**Architecture:** [Google Cloud and Stape measurement platform blueprint](../superpowers/plans/2026-07-25-google-cloud-stape-measurement-platform-blueprint.md)

## Live State

| Surface | Production state |
|---|---|
| Parent web GTM | `GTM-NZ6N7WNC`, container `250451797`, version `15` |
| Parent server GTM | `GTM-T7C46VM7`, container `259672853`, version `13` |
| First-party endpoint | `https://edge.cefa.ca`; DNS, TLS and health pass |
| GA4 | Live through Parent sGTM to `G-T65G018LYB` |
| Meta inquiry | Browser `Inquiry Submit` plus server `Inquiry Submit` with the same event ID |
| Google Ads inquiry | Existing browser tag remains live with the event ID as Transaction ID |
| Google Ads server copy | Live under the strict Parent `generate_lead`, hostname and event-ID guard |
| CEFA Conversion Tracking | Parent `0.6.4`; full runtime, attribution and ledger remain shadow |
| Gravity Forms/KinderTales | Unchanged |
| Existing dashboards | Unchanged; all new certified serving objects are additive and marked candidate |

## 1. GA4 Lead Payload Repair

Web version `15`, `CEFA | Parent | GA4 Lead Payload Guardrail | 2026-08-04`,
reduced the configured `generate_lead` event parameters from `41` to the GA4
limit of `25`. The live payload retains:

- `event_id`, `transaction_id`, and `cefa_event_id` with the same stable value;
- Form, school, program, value, currency, and success context;
- the compact canonical source/channel/campaign fields needed in GA4.

Bulky first/current-touch, raw click-ID, referrer, and redundant attribution
fields were removed from GA4 only. They remain available in the CEFA
first-party ledger, Gravity Forms, and BigQuery. Public-container read-back
confirmed exactly `25` configured parameters, the first-party server URL, the
Google Ads browser Transaction ID, and the Meta browser event ID.

## 2. Parent sGTM Completion

Server version `9`, `CEFA | Parent | Meta CAPI Inquiry Submit Live |
2026-08-04`, contains:

- the guarded native GA4 client and allowlisted GA4 destination;
- a strict Parent `generate_lead` trigger requiring the GA4 client,
  `cefa.ca` hostname, and non-empty event ID;
- live Meta CAPI delivery using the exact custom event name `Inquiry Submit`;
- the same event ID used by the browser event for platform deduplication;
- no generated Meta cookies and no repository-held token;
- paused native Google Conversion Linker and Google Ads server conversion
  tags;
- a paused Meta transport-test tag.

Meta transport proof passed twice:

- a direct PII-free Test Events request returned `events_received=1` with no
  messages;
- a propagated sGTM test returned Meta HTTP `200`, `events_received=1`, the
  exact event name, matching event ID, and no generated `_fbp` value.

Stape's 24-hour outgoing log later showed three accepted Facebook requests,
all HTTP `200` with `events_received=1` and no messages. Two occurred after the
production version was live and align with GA4 `generate_lead`/Google rows, so
they are likely legitimate production inquiries. This proves server receipt
and Meta acceptance, but it does not by itself prove that Meta merged each
browser/server pair. Events Manager deduplication remains a required read-back.

Server version `13` now keeps GA4, Meta CAPI, the Google Conversion Linker and
the Google Ads Inquiry Submit mirror live. A controlled saved Form `4` test
confirmed one Gravity entry, one valid signed collector event and one Stape
trace carrying the same event ID to GA4, Meta and Google. Google received the
same event ID as `oid`; Meta accepted one server event with no messages. The
browser GA4, Meta and Google tags continue to use that same Form `4` event ID.

The test browser did not originate from an ad click, so it is not expected to
create an attributed Google Ads reporting conversion. The acceptance evidence
proves transport and shared duplicate-protection identity. Continue the Meta
Events Manager merge read-back and Google diagnostics as operational QA. See
[Parent sGTM completion, 2026-08-05](./parent-sgtm-completion-2026-08-05.md).

## 3. Certified School And Source Reporting

The following additive BigQuery views are live:

- `mart_marketing.vw_parent_inquiry_certified_event`;
- `mart_marketing.vw_parent_inquiry_school_source_certified_daily`;
- `mart_marketing.vw_parent_inquiry_certified_qa_daily`;
- `mart_marketing.vw_parent_inquiry_measurement_model_dictionary`;
- `mart_cefa_growth_dashboard.dashboard_parent_inquiry_school_source_certified_daily_candidate`;
- `mart_cefa_growth_dashboard.dashboard_parent_inquiry_certified_qa_daily_candidate`.

Contract:

- one saved non-test Gravity Form `4` entry is one inquiry;
- Gravity Forms is the selected-school authority;
- the CEFA first-party attribution ledger is the source and paid-evidence
  authority;
- GA4 is joined only by exact CEFA event ID and supplies supporting session
  last-click context;
- ambiguous IDs, duplicate GA4 events, missing GA4 events, and source/school
  disagreements remain visible;
- no names, email addresses, phone numbers, child data, raw click IDs, IP
  addresses, addresses, or raw payloads are exposed;
- Meta and Google platform attribution windows remain separate because they
  cannot be reconstructed from GA4.

Production read-back through 2026-08-03:

| QA check | Result |
|---|---:|
| Stable-contract Form `4` entries since 2026-06-25 | `3,689` |
| Event view rows | `3,689` |
| Daily report submissions | `3,689` |
| Missing selected schools | `0` |
| Exact GA4 attribution-eligible rows | `3,331` (`90.3%`) |
| Ambiguous Gravity event-ID entries | `104` |
| Duplicate GA4 event-ID entries | `14` |
| GA4 event not observed | `271` |
| PII-like prohibited columns | `0` |

July alone reconciles to `3,025` saved inquiries. The report explicitly shows
where first-party paid evidence and GA4 disagree; since June 25, `823`
inquiries have first-party paid evidence while GA4 labels the session as
non-paid. These remain paid in the certified first-party view and are exposed
as `first_party_paid_ga4_non_paid` for diagnosis.

The six-row measurement dictionary explicitly prevents saved inquiries,
first-party paid evidence, GA4 delivery, GA4 session last-click, Google Ads
platform conversions, and Meta platform conversions from being added together.
The daily QA candidate keeps legacy identity ambiguity and delivery exceptions
visible without exposing PII.

## 4. Parent Event Identity Repair

Production read-only evidence found that the legacy browser event ID can be
reused when the same browser completes another successful Form `4` submission.
At the deployment checkpoint, `109` of `3,753` active post-contract entries
were affected by `45` duplicated legacy browser keys. The server-reserved IDs
were present on `2,370` shadow-era entries and had zero duplicates.

Parent plugin `0.6.4` now creates a new browser UUID after a previously
successful UUID is consumed, while preserving the same UUID through validation
retries. It does not change Form `4`, School Manager, KinderTales, attribution
writeback, the server-reserved identity, or destination tags. A GET-only
production check returned HTTP `200`, served the new code, and left the active
Form `4` entry count unchanged.

The Dataform cloud workspace now mirrors all `18` Git assertions. A committed
cloud compilation produced zero errors, and a full workflow invocation passed
`18/18`. No production Dataform schedule was created because the governed Git
and runtime release gate is still open.

## What Remains

1. Confirm the accepted Parent browser/server pairs are deduplicated in Meta
   Events Manager.
2. Monitor Parent GA4, Meta and Google server sends against saved Form `4`
   entries for the first 48 hours after server version `13`.
3. Keep Meta and Google platform-reported attribution-window reporting as a
   separate semantic layer; do not label GA4 session last-click as Meta
   seven-day click or one-day view.
4. Connect the candidate certified view to a Looker test data source only after
   dashboard owner QA; no existing dashboard contract was replaced.
5. Continue the separate Parent CRM/offline-conversion identity work when the
   GreenRope fields and controlled identity read-back are available.
6. Use the empty restricted Supabase outcome inbox only after BI verifies the
   v1 record-level source mappings, timestamps, corrections, lineage and one
   proof-of-concept record.

## Rollback

- Server version `12` restricts Google server delivery to the completed exact
  QA event and is the immediate narrow rollback.
- Server version `9` keeps GA4 and Meta live while pausing Google server tags.
- Server version `8` pauses the production Meta CAPI tag while retaining the
  guarded GA4 route.
- Web version `14` is the immediate pre-payload-guardrail version but exceeds
  the GA4 parameter limit; use only for emergency diagnosis.
- Web version `13` is the last version before the additional server identity
  aliases.
- Server version `1` is the pre-sGTM production rollback point.
- The certified BigQuery objects are additive views and can be disconnected
  from candidate reporting without changing source tables or dashboards.
