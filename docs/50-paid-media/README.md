# Paid Media Workstream

**Last updated:** 2026-07-27

This folder is for ad-account execution context that depends on conversion tracking, naming, BigQuery, and budget guardrails.

## Start Here

- [Measurement platform handover](../00-governance/measurement-platform-handover-2026-07-27.md)
- [Paid-media naming and copy standard](../40-naming-convention/cefa-paid-media-naming-and-copy-standard.md)
- [Conversion tracking workstream](../10-conversion-tracking/README.md)
- [Data taxonomy and question routing](../00-governance/data-taxonomy.md)

## Current Files

- [Paid media platform data availability, 2026-05-03](./platform-data-availability-2026-05-03.md)

## Rules

- Do not change live budgets from spreadsheet math alone.
- Do not change live campaigns or bidding without explicit approval.
- Do not use platform-reported conversions as business truth when CRM/KinderTales/BigQuery reconciliation is unresolved.
- Keep micro-conversions out of Google Ads bidding unless CEFA explicitly changes that decision.
- Conversion action definitions should link back to `docs/10-conversion-tracking/`.
- Naming should link back to `docs/40-naming-convention/`.
- Visible parent/enrollment copy must follow the CEFA Early Years wording
  guardrail in the naming standard.
- Use platform IDs for live object changes and read back URLs, UTMs, status,
  goals and targeting after implementation.
- This public repo receives aggregate status and contracts, not raw platform
  exports, credentials or private browser sessions.

## Suggested Next Files

- `ads-conversion-action-status.md`
- `meta-dataset-and-pixel-status.md`
- `google-ads-primary-secondary-conversions.md`
- `launch-qa-checklist.md`
