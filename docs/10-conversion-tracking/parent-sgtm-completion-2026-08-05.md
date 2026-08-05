# Parent sGTM Completion

**Date:** 2026-08-05

**Scope:** Parent `cefa.ca` only

**Status:** Production conversion routing complete; legacy Meta Gateway excluded; operational monitoring active

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

## Meta Browser And Server Route Normalization

The post-publish Meta read-back found that the parent dataset was receiving
server copies through two independent routes:

1. the legacy Meta-managed Conversions API Gateway / OpenBridge connection;
2. the new CEFA-owned Stape sGTM Meta CAPI tag.

This was visible in the correctly filtered Meta dataset statistics for
`Inquiry Submit`. Browser and server receipts were approximately one-to-one
before the Stape Meta route went live, while the partial 2026-08-05 UTC day
showed `49` browser receipts and `117` server receipts. These are raw transport
receipts, not deduplicated business inquiries, but the change proved that the
two server transports were overlapping.

At 2026-08-05 14:56 America/Vancouver, parent dataset
`918227085392601` was excluded only from the legacy business-managed
Conversions API connection. Meta UI read-back confirmed:

- the parent dataset moved from the connected list to the excluded list;
- the business connection changed from two connected datasets to one;
- Franchise USA dataset `1531247935333023` remained connected;
- Meta History recorded the parent dataset exclusion;
- the parent pixel, browser event, custom conversion, ad accounts and Stape
  direct CAPI configuration were not edited.

After propagation, the public parent pixel config no longer contained a
pixel-specific OpenBridge opt-in/configuration. A controlled non-conversion
homepage test still produced one browser Meta `PageView` and one first-party
GA4 `page_view` request through `edge.cefa.ca`, with no lead event and no
legacy Gateway request.

A synthetic Meta Test Events request then sent `Inquiry Submit` through the
direct CAPI endpoint. Meta returned HTTP `200`, `events_received=1`, zero
messages, and Events Manager displayed the event as `Processed`, source
`Server`, setup method `Manual setup`. The synthetic event used test-only
identity and did not create a Gravity Forms entry, KinderTales record or
production conversion.

The intended production topology is now one browser copy plus one Stape server
copy with the same exact event name and Form 4 event ID. Meta performs
deduplication from that shared event identity; there is no separate merge
switch to enable in Events Manager.

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
- Monitor correctly filtered Meta `Inquiry Submit` browser/server receipts for
  the next full production day. Investigate if the server-to-browser ratio
  remains materially above one after normal browser-blocking differences.
- Review Google Ads conversion diagnostics and action totals after normal
  platform processing lag; investigate repeated order IDs or unexplained
  inflation immediately.
- Keep Gravity Forms as inquiry truth and keep platform-attributed conversions
  as separate diagnostic/optimization measures.
- Do not expose Stape request bodies, platform credentials, parent/child PII or
  raw click IDs in Git or operational tickets.
