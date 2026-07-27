# Naming Convention

**Last updated:** 2026-07-27
**Status:** Active governed workstream

## Start Here

- [CEFA paid-media naming and copy standard](./cefa-paid-media-naming-and-copy-standard.md)
- [Measurement platform handover](../00-governance/measurement-platform-handover-2026-07-27.md)
- [Data taxonomy and source map](../00-governance/data-taxonomy.md)
- [AI-readable naming and conversion reference](./cefa-ai-naming-conversion-reference-2026-05-20.md)

The paid-media naming and copy standard is the current concise contract. The
older files below preserve inventories, workbook decisions, proof-of-concept
history, and migration evidence.

## Current Versions

| Family | State |
|---|---|
| Meta `NC1` | Current live baseline |
| Meta `NC2` | Proposed planning/build convention |
| Google `GADS1` | Proposed planning/build convention |
| Local listing `ll1` | Governed GBP/Yelp UTM family |

NC2 and GADS1 do not authorize broad live renaming. Refresh active-object
inventories and obtain approval before changing live names.

## Non-Negotiable Rules

- Use platform IDs for live joins, updates and renames.
- Do not silently change token meanings.
- New/imported Meta and Google objects default to `PAUSED` unless activation is
  explicitly approved.
- Use stable keys in UTMs rather than mutable display names.
- Keep parent program tokens separate from franchise topics.
- Do not treat Google Ads ads as having Meta-style visible ad names.
- Validate location, age range, landing page, UTM output and conversion goal
  before activation.
- Keyword targeting may use `daycare`, `childcare`, `child care`,
  `preschool`, and approved intent variants.
- Visible CEFA parent/enrollment ad copy must not use those terms. Use
  `CEFA Early Years` and/or `CEFA Early Years School`.

## Key Patterns

```text
Meta campaign:
CEFA | {BudgetScope} | {Activation} | {LocationOrGroup} | META | {Objective} | {Funnel} | {Theme} | {YYYYMM} | {Seq}

Google campaign:
CEFA | {BudgetScope} | {Activation} | {LocationOrGroup} | GOOGLE | {Channel} | {Objective} | {Funnel} | {Theme} | {YYYYMM} | {Seq}

Meta ad set:
{Persona} | {AudienceType} | {Geo} | {Placement}

Meta ad:
{FormatTag} | {ProgramOrTopic} | {VisualConcept} | {CopyAngle} | v{AdVersion}

Google Search ad group:
{PersonaOrIntent} | {KeywordTheme} | {GeoOrMarket} | {MatchStrategy}

Google PMax asset group:
Asset Group | {GeoOrMarket} | PMax
```

## Current Reference Files

- [Meta NC2 active last-30 inventory](./meta-naming-nc2-active-last-30-inventory-2026-05-04.md)
- [Google GADS1 active last-30 inventory](./google-ads-naming-gads1-active-last-30-inventory-2026-05-04.md)
- [Meta creative build manifest](./meta-creative-build-import-manifest-2026-05-04.md)
- [Paid-media build control center POC](./paid-media-build-control-center-poc-2026-05-05.md)
- [Paid-media build control center v21](./paid-media-build-control-center-v21-final-poc-2026-05-06.md)
- [Meta bulk import success pattern](./meta-bulk-import-success-pattern-2026-05-05.md)
- [Budget-driven Meta v20/final-v3 review](./budget-driven-meta-naming-v20-final-v3-review-2026-05-04.md)
- [Budget-driven Meta v19 review](./budget-driven-meta-naming-v19-review-2026-05-04.md)
- [Local listing UTM rules](./local-listing-utm-rules-gbp-yelp-2026-05-03.md)

## Current Gaps

- Active-object inventories are dated and must be refreshed before live
  migration.
- NC2/GADS1 remain candidate conventions.
- Current Meta/Google import schemas must be revalidated before material bulk
  operations.
- The v21 workbook is a planning/build surface, not autonomous production
  authority.
- n8n remains validation/export/audit-first and has no autonomous spend,
  bidding, activation or broad-rename authority.

## Where To Record Changes

- Update the paid-media standard when a governed token, UTM, copy, or safety
  rule changes.
- Update the platform inventory when live objects are re-read.
- Record actual campaign/ad implementation in `docs/50-paid-media/`.
- Update the program register when a naming version is promoted or a major
  migration is approved.
