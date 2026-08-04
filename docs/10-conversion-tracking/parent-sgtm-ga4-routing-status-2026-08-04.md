# Parent sGTM GA4 Routing Status

**Date:** 2026-08-04  
**Scope:** Parent `cefa.ca` only  
**Canonical program:** [Measurement and activation program register](../00-governance/measurement-and-activation-program-register-2026-07-23.md)  
**Architecture:** [Google Cloud and Stape measurement platform blueprint](../superpowers/plans/2026-07-25-google-cloud-stape-measurement-platform-blueprint.md)

## Current State

The Parent site now routes its existing GA4 Google tag through the guarded
first-party Stape endpoint. Google Ads and Meta conversion delivery remain on
their existing browser paths and were not changed in this release.

| Surface | Current state |
|---|---|
| Parent server GTM | `GTM-T7C46VM7`, container `259672853` |
| Published server version | Version `2`, `CEFA | Parent | sGTM Guarded GA4 Baseline | 2026-08-04` |
| First-party endpoint | `https://edge.cefa.ca`, TLS and `/healthy` pass |
| Stape hosting | Parent Business in `CA East (Canada)`, running |
| Parent web GTM | `GTM-NZ6N7WNC`, container `250451797` |
| Published web version | Version `12`, `CEFA | Parent | GA4 via First-Party sGTM | 2026-08-04` |
| Live web routing | On for Parent GA4 through `https://edge.cefa.ca` |
| Published web change | Exactly one change added `server_container_url=https://edge.cefa.ca` to Google tag `35` while preserving `send_page_view=true` |
| Web rollback | Version `11`, `CEFA parent ad attribution GA4 mapping - 2026-07-08` |

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

Existing Google Ads, Meta, Gravity Forms, School Manager, KinderTales, CRM, and
franchise behavior remains unchanged.

## Production Follow-Up

1. Monitor Stape incoming/outgoing logs and GA4 event/session parity during the
   normal production flow.
2. Confirm the next legitimate `generate_lead` follows the first-party GA4
   route once and still corresponds to one saved Form `4` entry.
3. Keep Google Ads and Meta server conversion delivery off until each
   destination's separate deduplication and consent gates pass.

## Later Destination Work

- Google Ads server conversion delivery remains off until browser and server
  copies share the same stable transaction identity and deduplication is
  proven.
- Meta CAPI remains off until the approved access token is stored outside Git,
  the browser and server copies share the same `event_id`, and advertising
  consent gating is defined.
- No global default-denied Consent Mode change is approved without an
  operational CMP. Native Google server tags will consume consent signals from
  the web request when that layer exists.
- Franchise Canada and Franchise USA remain outside this Parent container.

## Rollback

- Publish web version `11` to restore the pre-sGTM GA4 browser route if live
  parity, availability, or conversion continuity regresses.
- Server version `1` is the pre-rollout server rollback point.
- Stape container configuration, domain settings, analytics, logs, and
  monitoring remain CEFA-owned and must not contain repository secrets.
