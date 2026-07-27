# Live WordPress Tracking Plugin Inventory

**Checked:** 2026-07-27
**Method:** Read-only WP-CLI over WP Engine SSH
**Status:** Verified inventory; responsibilities remain governed by their
owning contracts

## Purpose

Record the active WordPress plugins that can affect forms, tracking,
attribution, CRM delivery, email feeds, tag injection, or operational context
on the three CEFA measurement properties.

This inventory does not authorize plugin updates, deactivation, configuration
changes, snippet edits, or feed changes.

## Measurement-Critical Components

| Component | Parent | Franchise Canada | Franchise USA | Responsibility |
|---|---:|---:|---:|---|
| CEFA Conversion Tracking | `0.6.3` | `0.6.3` | `0.6.3` | Neutral events, identity, attribution, duplicate controls and guarded shadow capabilities |
| CEFA School Manager | `1.0.22` | Not active | Not active | Parent Form 4 school/program/day behavior and KinderTales delivery |
| Gravity Forms | `2.10.5` | `2.10.5` | `2.10.5` | Saved form records |
| CEFA Franchise MCP Control | Not active | `0.1.16` | `0.1.13` | Franchise Synuma delivery and operational control |
| WPCode / Insert Headers and Footers | `2.3.7` | `2.3.7` | `2.3.7` | Existing custom snippets and fallback bridge behavior |
| Gravity Forms Mailchimp | `5.7.2` | `5.7.2` | `5.7.2` | Mailchimp feeds; parent Form 4 feed requires review before omnichannel expansion |
| Gravity Forms Webhooks | `1.7.0` | Not active | Not active | Parent webhook feeds |
| Gravity Forms Zoho CRM | `2.4.0` | Not active | Not active | Parent CRM add-on surface; verify feed ownership before relying on it |
| Gravity Forms Google Analytics | Not active | Not active | `2.4.1` | USA analytics add-on; must not create a duplicate final conversion |
| Gravity Forms reCAPTCHA | `2.2.2` | `2.2.2` | `2.2.2` | Form abuse protection |
| Google Site Kit | `1.183.0` | Not active | Not active | Parent Google integration surface; not the owner of CEFA final-event mapping |

## CEFA Conversion Tracking Runtime

Both franchise properties were verified on:

- `runtime_profile=attribution_only`;
- `attribution_mode=shadow`;
- `ledger_mode=shadow`;
- CRM identity disabled;
- payload v2 disabled;
- collector disabled.

Parent uses the same plugin version with its separately governed parent
attribution/writeback configuration. Confirm the current parent constants
before a release; do not copy franchise settings onto parent.

## Full Active Inventory

### Parent `cefa.ca`

| Plugin | Version |
|---|---:|
| AltText AI | `1.10.35` |
| CEFA Conversion Tracking | `0.6.3` |
| CEFA MCP Abilities | `1.3.0` |
| CEFA Markham Schema POC | `0.2.0` |
| CEFA Owly Chatbot | `3.3.7` |
| CEFA School Manager | `1.0.22` |
| Duplicate Page | `4.5.9` |
| FileBird | `6.5.5` |
| Gravity Forms | `2.10.5` |
| Gravity Forms Mailchimp | `5.7.2` |
| Gravity Forms reCAPTCHA | `2.2.2` |
| Gravity Forms Webhooks | `1.7.0` |
| Gravity Forms Zoho CRM | `2.4.0` |
| MCP Adapter | `0.5.0` |
| Redirection | `5.9.0` |
| Simple Custom Post Order | `2.8.4` |
| Simple History | `5.29.0` |
| Google Site Kit | `1.183.0` |
| SMTP2GO | `1.17.0` |
| Smush Pro | `4.2.0` |
| WP All Export | `1.5.0` |
| WPCode / Insert Headers and Footers | `2.3.7` |
| WPMU DEV Dashboard | `5.0.0` |
| Yoast SEO | `28.0` |
| Yoast SEO Premium | `28.0` |
| Yoast Test Helper | `1.19` |

### Franchise Canada `franchise.cefa.ca`

| Plugin | Version |
|---|---:|
| CEFA Conversion Tracking | `0.6.3` |
| CEFA Franchise MCP Control | `0.1.16` |
| Duplicate Page | `4.5.9` |
| FileBird | `6.5.5` |
| Gravity Forms | `2.10.5` |
| Gravity Forms Mailchimp | `5.7.2` |
| Gravity Forms reCAPTCHA | `2.2.2` |
| MCP Adapter | `0.5.0` |
| Redirection | `5.9.0` |
| Simple History | `5.29.0` |
| SMTP2GO | `1.17.0` |
| Smush Pro | `3.23.4` |
| WP All Import | `4.1.1` |
| WPCode / Insert Headers and Footers | `2.3.7` |
| Yoast SEO | `28.0` |

### Franchise USA `franchisecefa.com`

| Plugin | Version |
|---|---:|
| CEFA Conversion Tracking | `0.6.3` |
| CEFA Franchise MCP Control | `0.1.13` |
| Duplicate Page | `4.5.9` |
| FileBird | `6.5.5` |
| Gravity Forms | `2.10.5` |
| Gravity Forms Google Analytics | `2.4.1` |
| Gravity Forms Mailchimp | `5.7.2` |
| Gravity Forms reCAPTCHA | `2.2.2` |
| MCP Adapter | `0.5.0` |
| Redirection | `5.9.0` |
| Simple History | `5.29.0` |
| SMTP2GO | `1.17.0` |
| Smush Pro | `3.23.4` |
| WP All Import | `4.1.1` |
| WPCode / Insert Headers and Footers | `2.3.7` |
| Yoast SEO | `28.0` |

## Known Risks And Follow-Up

1. Franchise Canada and USA run different CEFA Franchise MCP Control versions.
   Compare code and live behavior before standardization.
2. WPCode is active on all properties. Inventory active snippets before
   modifying a plugin or tag so the same event is not emitted twice.
3. Gravity Forms Mailchimp is active on all properties. Parent Form 4 has an
   existing feed with sensitive mapped fields and no confirmed feed-level
   opt-in condition in the July 25 inventory. Back up and review it before
   expanding Mailchimp use.
4. Gravity Forms Google Analytics is active only on Franchise USA. Keep it
   audit/reporting-only unless a documented event-ownership change is
   approved.
5. Parent has both Gravity Forms Webhooks and Zoho CRM add-ons. Verify actual
   active feeds and destinations rather than assuming plugin activation means
   a feed is in use.
6. This repository is public. Do not commit private plugin credentials,
   Synuma payloads, Mailchimp data, or raw form exports.

## Recheck Procedure

1. Run read-only `wp plugin list --status=active`.
2. Compare measurement-critical versions with this file.
3. Inspect feeds/snippets only through approved read-only methods.
4. Record changes here and in the program register if ownership or risk
   changes.
5. Never update or deactivate a plugin as part of an inventory check.
