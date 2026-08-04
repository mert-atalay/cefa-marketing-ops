# Parent sGTM GA4 Routing Status

**Date:** 2026-08-04  
**Scope:** Parent `cefa.ca` only  
**Canonical program:** [Measurement and activation program register](../00-governance/measurement-and-activation-program-register-2026-07-23.md)  
**Architecture:** [Google Cloud and Stape measurement platform blueprint](../superpowers/plans/2026-07-25-google-cloud-stape-measurement-platform-blueprint.md)

## Current State

The Parent site now routes its existing GA4 Google tag through the guarded
first-party Stape endpoint. Google Ads and Meta conversion delivery remain on
their existing browser paths. The Google Ads browser inquiry tag now uses the
existing stable event ID as its transaction ID, and the GA4 `generate_lead`
request now carries the same ID as `event_id`, `transaction_id`, and
`cefa_event_id` so a later server copy can deduplicate safely.

| Surface | Current state |
|---|---|
| Parent server GTM | `GTM-T7C46VM7`, container `259672853` |
| Published server version | Version `2`, `CEFA | Parent | sGTM Guarded GA4 Baseline | 2026-08-04` |
| First-party endpoint | `https://edge.cefa.ca`, TLS and `/healthy` pass |
| Stape hosting | Parent Business in `CA East (Canada)`, running |
| Parent web GTM | `GTM-NZ6N7WNC`, container `250451797` |
| Published web version | Version `14`, `CEFA | Parent | sGTM Ads Event Contract | 2026-08-04` |
| Live web routing | On for Parent GA4 through `https://edge.cefa.ca` |
| Google Ads browser dedup | Version `13` added `{{DLV - event_id}}` as Transaction ID to existing inquiry tag `38` |
| Server event contract | Version `14` added `transaction_id` and `cefa_event_id` aliases to existing GA4 `generate_lead` tag `36` |
| Server conversion delivery | Off; server version `3` is staged but unpublished and both Google tags are paused |
| Web rollback | Version `13` removes only the GA4 aliases; version `12` removes both 2026-08-04 dedup additions |

## Published Server Guardrails

Server version `2` contains:

- the native GA4 client with first-party server cookie support;
- the PII-free exact health event route for `cefa_sgtm_shadow_health`;
- native server GA4 tag `CEFA | Parent | GA4 | Allowed Website Events`;
- `Client Name = GA4` enforcement;
- an anchored `cefa.ca` / `www.cefa.ca` `page_location` requirement;
- an explicit event allowlist for Parent analytics and diagnostic events;
- IP redaction in the server GA4 tag;
- event-data variables for `page_location`, `cefa_event_id`, and `event_id`.

The route excludes arbitrary events, other hostnames, franchise properties,
CRM lifecycle events, Meta CAPI, and Google Ads conversion delivery.

## Test Evidence

The established preview test remains valid:

- the synthetic health request returned HTTP `200` from the first-party
  endpoint;
- only the exact health route fired;
- GA4 returned HTTP `204`;
- Stape outgoing logs recorded the matching GA4 delivery;
- no PII and no conversion event were used.

On 2026-08-04, version `2` was created and published, and the Stape container
was verified as running with the intended GTM Container Configuration.
Controlled no-preview requests then passed the four-case routing matrix:

- the exact health event on `cefa.ca` sent once;
- an allowlisted non-conversion event on `cefa.ca` sent once;
- the same event on another hostname sent zero times;
- a non-allowlisted event on `cefa.ca` sent zero times;
- Stape recorded exactly two intended GA4 deliveries, both HTTP `204`.

Web version `12` was then created and published. A clean public homepage load
returned HTTP `200`, made one GA4 collection request to `edge.cefa.ca`, made no
direct browser request to a Google Analytics collection hostname, and produced
one Stape `PageView` delivery to GA4 with HTTP `204`. No form was submitted and
no conversion event was generated during this smoke test.

No destination, conversion action, trigger, campaign goal, Gravity Forms,
School Manager, KinderTales, CRM, Meta, or franchise route was replaced or
enabled by these changes.

## Browser Deduplication And Server Preparation

Web version `13` changed only the existing Google Ads Parent inquiry tag `38`:

- conversion ID `802334988` and label `cFt-CMrLufgCEIzSyv4C` are unchanged;
- value `150` and currency `CAD` are unchanged;
- trigger `6`, exact custom event `school_inquiry_submit`, is unchanged;
- enhanced conversions remain disabled;
- `{{DLV - event_id}}` is now the Google Ads Transaction ID.

Web version `14` changed only the existing GA4 `generate_lead` tag `36`:

- existing `event_id={{DLV - event_id}}`, value `150`, currency `CAD`, school,
  program, and attribution parameters are unchanged;
- `transaction_id={{DLV - event_id}}` and
  `cefa_event_id={{DLV - event_id}}` were added;
- the same trigger and GA4 measurement destination remain in use.

The public version `14` container was read back and contains one copy of the
existing Google Ads conversion label, `vtp_orderId` mapped to macro `1`, and
the three identity names mapped to that same macro. Meta browser tag `40`
continues to use the same event ID in its `eventID` option.

An isolated server workspace produced validated but unpublished version `3`,
`STAGED - CEFA | Parent | Ads and Meta Server Routes | 2026-08-04`. It contains:

- trigger `12`, requiring GA4 Client Name, exact `generate_lead`, a Parent
  `cefa.ca` page location, and a non-empty event ID;
- paused native server Conversion Linker tag `13`;
- paused native server Google Ads conversion tag `14` using the existing
  conversion ID and label;
- Stape gallery template `Facebook Conversion API`, pinned by GTM to gallery
  version `6769a59cb8e5a8fc6aa0d3c45a2f7b49d39dfff5`;
- no Meta CAPI tag or token.

Server production remains version `2`. A post-build endpoint check returned
HTTP `200`, and a PII-free `cefa_sgtm_shadow_health` request returned HTTP
`200` without generating a conversion.

## Production Follow-Up

1. Monitor Stape incoming/outgoing logs and GA4 event/session parity during the
   normal production flow.
2. Confirm the next legitimate `generate_lead` reaches sGTM once with matching
   `event_id`, `transaction_id`, and `cefa_event_id`, and still corresponds to
   one saved Form `4` entry.
3. Keep server version `3` unpublished until one controlled Form `4` test proves
   the browser and server copies share the same identity and only one platform
   conversion is counted.
4. Add the Meta dataset token outside Git, create a paused Meta tag using the
   staged template, and prove browser/CAPI event-ID deduplication in Test Events.

## Later Destination Work

- Google Ads browser transaction identity is now live. Its server tag remains
  paused and unpublished until controlled duplicate-counting QA passes.
- Meta browser event identity is already live and the server template/trigger
  are staged. Meta CAPI remains off until the approved access token is stored
  outside Git and controlled browser/CAPI deduplication passes.
- No global default-denied Consent Mode change is approved without an
  operational CMP. Native Google server tags will consume consent signals from
  the web request when that layer exists.
- Franchise Canada and Franchise USA remain outside this Parent container.

## Rollback

- Publish web version `13` to remove only the server event aliases while
  retaining Google Ads browser duplicate protection.
- Publish web version `12` to restore the state before both browser
  deduplication additions.
- Publish web version `11` only to restore the pre-sGTM GA4 browser route.
- Server version `1` is the pre-rollout server rollback point.
- Stape container configuration, domain settings, analytics, logs, and
  monitoring remain CEFA-owned and must not contain repository secrets.
