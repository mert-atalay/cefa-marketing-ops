# CEFA Paid-Media Naming And Copy Standard

**Last updated:** 2026-07-27
**Owner:** CEFA marketing
**Status:** Current governed standard for new planning and QA

## Scope

This standard governs:

- Meta and Google campaign structure names;
- stable reporting keys;
- UTMs and agency/test markers;
- visible parent/enrollment copy guardrails;
- safe build, import, rename, and QA behavior.

It does not approve a broad rename of existing live objects.

## Current Versions

| Family | State | Use |
|---|---|---|
| Meta `NC1` | Current live baseline | Preserve existing live semantics |
| Meta `NC2` | Proposed planning/build convention | New build planning and reviewed migration candidates |
| Google `GADS1` | Proposed planning/build convention | New build planning and reviewed migration candidates |
| Local listing `ll1` | Governed UTM family | GBP/Yelp school links after school-slug validation |

No agent or automation may silently reinterpret a token or treat a candidate
name as permission to rename a live object.

## Stable Object Rules

- Use platform IDs for live reads, joins, updates, and renames.
- Never use a mutable campaign, ad set, ad group, asset group, or ad name as
  the only object selector.
- A planning key is not a platform object ID.
- New/imported objects default to `PAUSED` unless activation is explicitly
  approved.
- Google Ads have no Meta-style ad name contract. Use `ad_id` plus a stable
  `ad_build_key`.

## Naming Patterns

### Campaign

```text
CEFA | {BudgetScope} | {Activation} | {LocationOrGroup} | {Platform} | {ChannelOrObjective} | {ObjectiveOrFunnel} | {FunnelOrTheme} | {ThemeOrYYYYMM} | {YYYYMMOrSeq} | {OptionalSeq}
```

Use the established platform-specific forms:

```text
Meta:
CEFA | {BudgetScope} | {Activation} | {LocationOrGroup} | META | {Objective} | {Funnel} | {Theme} | {YYYYMM} | {Seq}

Google:
CEFA | {BudgetScope} | {Activation} | {LocationOrGroup} | GOOGLE | {Channel} | {Objective} | {Funnel} | {Theme} | {YYYYMM} | {Seq}
```

### Meta ad set

```text
{Persona} | {AudienceType} | {Geo} | {Placement}
```

### Meta ad

```text
{FormatTag} | {ProgramOrTopic} | {VisualConcept} | {CopyAngle} | v{AdVersion}
```

### Google Search ad group

```text
{PersonaOrIntent} | {KeywordTheme} | {GeoOrMarket} | {MatchStrategy}
```

### Google Performance Max asset group

```text
Asset Group | {GeoOrMarket} | PMax
```

### Creative group key

```text
{school_slug}__{scope}__{funding}__{activation}__{theme}__{format}__{concept}__cr##__v#
```

## Required Stable Keys

| Key | Purpose |
|---|---|
| `campaign_key` | Campaign reporting and UTM identity |
| `ad_set_key` | Meta ad-set reporting identity |
| `ad_group_key` | Google ad-group reporting identity |
| `asset_group_key` | PMax asset-group reporting identity |
| `ad_data_key` | Meta ad-level UTM/content key |
| `ad_build_key` | Google ad build/reporting key |
| `campaign_slot` | Budget/control-sheet planning row |
| `copy_template_slot` | Internal copy template identity |
| `creative_slot` | Internal creative identity |
| Platform object IDs | Live object handles |

## UTM Standard

### Meta paid social

```text
utm_source=meta
utm_medium=paid_social
utm_campaign={campaign_key}
utm_content={ad_data_key}
utm_term={ad_set_key}
```

### Google paid search and PMax

```text
utm_source=google
utm_medium=cpc
utm_campaign={campaign_key}
utm_content={ad_build_key}
utm_term={keyword_or_ad_group_key}
```

Google auto-tagging remains enabled. `gclid`, `gbraid`, or `wbraid` is the
preferred matching evidence when valid; UTMs remain reporting and fallback
context.

### Local listings

```text
utm_source=google_business_profile|yelp
utm_medium=local_listing
utm_campaign=parents_school_location|parents_school_inquiry
utm_content={school_slug}__website|{school_slug}__inquiry_form
utm_id=ll1__{platform}__{school_slug}__{intent}
```

### Partnerships and merchant pages

Use one stable partner name and a non-paid partnership medium:

```text
utm_source={partner_slug}
utm_medium=partner_referral
utm_campaign={initiative_key}
utm_content={placement_or_cta_key}
```

Do not label partnership traffic `cpc` or `paid_social` unless it is actually
bought through that channel.

## Agency And Test Markers

Use UTMs for channel/campaign reporting and a separate stable marker only when
the conversion must be segmented by test owner.

Current Franchise USA in-house marker:

```text
cefa_agency_test=fr_us_in_house
```

Rules:

- the marker must persist from landing to confirmed inquiry;
- browser Pixel and server CAPI copies must use the same `event_id`;
- the marker may filter a reporting custom conversion;
- the standard final business event remains `Lead` or the governed neutral
  inquiry event;
- low-volume campaigns should optimize to the shared primary event and use the
  custom conversion for reporting;
- do not manufacture a partner marker when the partner campaign already has a
  stable, governed conversion distinction and no test requires one.

## Visible Copy Guardrail

This rule is strict for CEFA parent/enrollment advertising.

Allowed in keyword targeting and search-intent research:

- `daycare`;
- `childcare`;
- `child care`;
- `preschool`;
- related intent-language variants approved for targeting.

Prohibited in visible CEFA parent/enrollment copy:

- headlines;
- long headlines;
- descriptions;
- primary text;
- display copy;
- extensions/assets containing promotional copy.

Required brand language:

- `CEFA Early Years`;
- `CEFA Early Years School`;
- a grammatically correct location/program variation using those terms.

Examples:

```text
Use: CEFA Early Years School
Use: Ontario Early Years School
Use: Find a CEFA Early Years School

Do not use: CEFA Daycare
Do not use: Find Childcare Near You
Do not use: Private Preschool in Ontario
```

The targeting language and visible-copy language are intentionally different.
Search intent may contain category words that CEFA does not use as brand copy.

## Location And Destination Rules

- Campaign geo, copy, school/program age range, and landing page must agree.
- Do not reuse Ontario wording for BC or Alberta without changing geography
  and age range.
- BC parent regional early-years copy uses ages `1-5`.
- Alberta parent regional early-years copy uses ages `1-6`.
- Use the canonical destination page or approved school/region finder state.
- Preserve query parameters required by the destination experience.
- Put tracking parameters in the approved final URL suffix or URL parameter
  contract without breaking required destination parameters.
- Validate the final URL, redirect chain, school/region state, and UTMs before
  activation.

## Build And Rename Workflow

1. Identify the platform account and object IDs.
2. Select the governed naming family and stable keys.
3. Confirm business unit, location, objective, funnel, theme, date, and
   sequence.
4. Confirm final URL and UTM output.
5. Run the visible-copy prohibited-term check.
6. Validate geography, program, age range, conversion goal, and destination.
7. Create/import in `PAUSED` state unless activation is explicitly approved.
8. Read back IDs, names, URLs, suffixes, status, and conversion settings.
9. Record the change in the paid-media implementation note.

## Current Gaps

- NC2 and GADS1 are not approved as blanket live rename programs.
- Active-object inventories are dated and must be refreshed before live
  rename or migration.
- The v21 control workbook remains a planning/build surface, not autonomous
  production authority.
- Import templates must be revalidated against current Meta and Google schemas
  before each material bulk operation.
- n8n automation remains validation/export/audit-first; no autonomous spend,
  activation, bidding, or broad rename authority is granted.

## Historical References

- [AI-readable naming and conversion reference](./cefa-ai-naming-conversion-reference-2026-05-20.md)
- [Meta NC2 active-object inventory](./meta-naming-nc2-active-last-30-inventory-2026-05-04.md)
- [Google GADS1 active-object inventory](./google-ads-naming-gads1-active-last-30-inventory-2026-05-04.md)
- [Meta creative build manifest](./meta-creative-build-import-manifest-2026-05-04.md)
- [Paid-media build control center v21](./paid-media-build-control-center-v21-final-poc-2026-05-06.md)
- [Local listing UTM rules](./local-listing-utm-rules-gbp-yelp-2026-05-03.md)
