# Parent sGTM Completion

**Date:** 2026-08-05

**Scope:** Parent `cefa.ca` only

**Status:** Production conversion routing complete; operational monitoring active

## Production State

| Surface | Live state |
|---|---|
| Parent web GTM | `GTM-NZ6N7WNC`, container `250451797`, version `15` |
| Parent server GTM | `GTM-T7C46VM7`, container `259672853`, version `13` |
| First-party endpoint | `https://edge.cefa.ca` |
| GA4 | `generate_lead` routed through Parent sGTM to `G-T65G018LYB` |
| Meta | Browser and CAPI `Inquiry Submit` live with the same Form 4 event ID |
| Google Ads | Browser and server `Inquiry Submit_ollo` live with the same Form 4 event ID/order ID |
| Gravity Forms and KinderTales | Existing Form 4 and business-delivery logic unchanged |
| Campaigns and bidding | Unchanged |

Server version `13`, `CEFA | Parent | sGTM Google Inquiry Live |
2026-08-05`, completes the Parent server-routing phase. The live Google server
tag now uses the same strict trigger as Meta CAPI:

- GA4 client only;
- event name exactly `generate_lead`;
- page location restricted to `cefa.ca`;
- non-empty event ID;
- one server tag fire per event.

The temporary exact-event canary trigger was removed from the production
container.

## Controlled Acceptance Test

One labelled Form 4 QA submission was sent with `qa_tracking` attribution and
an explicit do-not-contact comment. The QA markers exclude the record from
certified business reporting.

Read-back confirmed:

1. Form 4 saved exactly one active entry and preserved the generated event ID,
   selected school, program, days and QA attribution fields.
2. The signed first-party collector accepted one `school_inquiry_submit` event
   with a valid signature and the same event ID.
3. One Stape trace carried the same event ID to all enabled server
   destinations:
   - GA4 `GenerateLead`: HTTP `204`;
   - Meta: HTTP `200`, `events_received=1`, zero messages;
   - Google conversion endpoint: HTTP `302`, with `oid` equal to the Form 4
     event ID, value `150` and currency `CAD`;
   - Google conversion continuity endpoint: HTTP `200`.
4. Live web-container read-back confirmed:
   - GA4 sends `event_id`, `transaction_id` and `cefa_event_id` from the same
     data-layer event ID;
   - Google Ads uses that event ID as `orderId`;
   - Meta browser `Inquiry Submit` uses that event ID as `eventID`.
5. The form reached `/thank-you/` with no validation error. Existing Form 4,
   School Manager and KinderTales configuration was not edited.

The controlled browser was not an ad-click session. It therefore proves
transport, shared identity and duplicate-protection wiring, but it is not
expected to create an attributed Google Ads reporting conversion. Google and
Meta platform diagnostics remain operational read-backs rather than inquiry
truth.

## Version History And Rollback

| Server version | Purpose |
|---|---|
| `13` | Current production: GA4, Meta CAPI, Google Conversion Linker and Google Ads Inquiry Submit live under strict guards |
| `12` | Exact one-event Google canary; immediate narrow rollback |
| `9` | GA4 and Meta live; Google server tags paused |
| `8` | GA4 guarded; production Meta CAPI paused |
| `1` | Pre-production sGTM rollback |

Use version `12` to restrict Google server delivery immediately. Use version
`9` to disable Google server conversion delivery while preserving GA4 and Meta.
Do not change Gravity Forms, KinderTales or the browser destinations as an sGTM
rollback mechanism.

## Operational Follow-Up

- Monitor saved Form 4 entries, GA4 `generate_lead`, Meta CAPI and Google
  server sends daily for the first 48 hours.
- Confirm Meta browser/server merge quality in Events Manager when the UI
  read-back is available.
- Review Google Ads conversion diagnostics and action totals after normal
  platform processing lag; investigate repeated order IDs or unexplained
  inflation immediately.
- Keep Gravity Forms as inquiry truth and keep platform-attributed conversions
  as separate diagnostic/optimization measures.
- Do not expose Stape request bodies, platform credentials, parent/child PII or
  raw click IDs in Git or operational tickets.
