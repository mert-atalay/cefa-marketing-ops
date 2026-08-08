# Parent Measurement Operations Runbook

**Date:** 2026-08-04  
**Scope:** Parent `cefa.ca`, Stape Parent sGTM, certified inquiry reporting  
**Normal owner:** CEFA marketing measurement

## Guardrails

- Gravity Forms Form `4` is inquiry truth.
- School Manager owns KinderTales delivery and business fields.
- Do not submit a real test inquiry without an approved test identity and
  business-reporting exclusion.
- Keep Google server inquiry delivery on the strict Parent `generate_lead`,
  hostname and non-empty-event-ID trigger. Do not broaden it.
- Do not call a Meta send deduplicated until Events Manager confirms the pair.
- Do not expose Stape request payloads, tokens, form PII or click IDs in tickets
  or public Git.

## Normal State

| Check | Expected |
|---|---|
| `https://edge.cefa.ca/healthy` | HTTP `200`; the endpoint root may return `404` by design |
| Parent web/server GTM | Web `15`; server `13` |
| GA4 outgoing | HTTP `204` |
| Meta outgoing | HTTP `200`, `events_received=1`, no messages |
| Google server conversion | Live; conversion endpoint `302` and continuity endpoint `200` are expected for the validated route |
| Stape alerts | Incoming `5xx`, outgoing `4xx`, outgoing `5xx`; one recipient |
| Parent plugin | `0.6.4`, full runtime, attribution/ledger shadow |
| Certified Dataform QA | `18/18` passing |

## Alert Response

### Incoming 5xx

1. Confirm `edge.cefa.ca/healthy` returns HTTP `200` with valid TLS from a
   clean request.
2. Check Stape container status and recent incoming logs without opening raw
   user payloads.
3. If failures continue, pause server destination expansion. Do not touch Form
   `4` or KinderTales.
4. If the first-party endpoint is broadly unavailable, use the reviewed web
   GTM pre-sGTM rollback version and document the exact time.

### Outgoing 4xx

1. Identify only destination, tag, status code and event class.
2. Treat repeated Meta `400/401/403` as credential or payload failures and
   pause the Meta server tag through a reviewed server-container version.
3. Leave the browser destination unchanged unless separate evidence shows it
   is also failing.

### Outgoing 5xx

1. Confirm whether the destination is Meta, GA4 or Google and whether retries
   recovered.
2. For repeated failures, pause only the affected server tag. Preserve GA4 and
   browser paths where healthy.
3. Record start/end time and aggregate affected-event count; never record raw
   request bodies.

## Daily Read-Only Health

1. Check Stape request volume, HTTP status mix and alert state.
2. Check the latest
   `mart_marketing.vw_parent_inquiry_certified_qa_daily` row.
3. Confirm saved-inquiry totals reconcile to the certified event/daily views.
4. Review legacy ambiguous IDs, missing GA4 events and source disagreements as
   QA signals; do not subtract them from Gravity inquiry truth.
5. Run the Dataform `certified_reporting` tag after reporting SQL changes and
   the full `18`-assertion package before release promotion.

## Rollback Points

- Server GTM `12`: exact one-event Google canary and immediate narrow rollback.
- Server GTM `9`: GA4 and Meta live; Google server tags paused.
- Server GTM `8`: pauses production Meta CAPI and retains guarded GA4.
- Server GTM `1`: pre-sGTM server rollback.
- Web GTM `14`: immediate pre-parameter-guardrail diagnostic version; it exceeds
  the GA4 parameter limit and is not a preferred steady state.
- Web GTM `11`: pre-sGTM browser route.
- Parent plugin rollback must use a reviewed prior Git artifact through the
  standard WordPress release process.
- BigQuery certified and Supabase inbox objects are additive. Disconnect
  candidate readers rather than changing existing dashboard contracts.

## Escalation Gates

- Meta: Events Manager duplicate/merge evidence is required.
- Google: monitor conversion diagnostics, repeated order IDs and unexplained
  inflation after the 2026-08-05 server activation.
- Supabase: BI read-only schema, mappings and a proof-of-concept record are
  required before ingestion.
- CRM outcomes: GreenRope/KinderTales exact CEFA identity fields and read-back
  are required before dispatch.
