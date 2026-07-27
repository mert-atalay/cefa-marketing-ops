# Growth Operations

**Last updated:** 2026-07-27
**Status:** Active governed workstream

## Purpose

This workstream connects CEFA marketing systems and teams across acquisition,
measurement, CRM, reporting and activation. It owns cross-workstream process
clarity; it does not replace the narrower technical or platform owners.

## Start Here

1. [Marketing operations context layer](../00-governance/marketing-operations-context-layer.md)
2. [System and integration register](./system-and-integration-register.md)
3. [Gap, risk and scenario register](./gap-risk-and-scenario-register.md)
4. [Measurement platform handover](../00-governance/measurement-platform-handover-2026-07-27.md)
5. [Program register](../00-governance/measurement-and-activation-program-register-2026-07-23.md)
6. [Marketing and BI alignment independent-review brief](./marketing-bi-alignment-independent-review-brief-2026-07-27.md)
7. [Marketing and BI alignment final decision and email](./marketing-bi-alignment-final-decision-and-email-2026-07-27.md)

## This Workstream Owns

- end-to-end source and integration visibility;
- cross-channel handoffs and operational dependencies;
- unresolved-gap and external-dependency tracking;
- incident and what-if routing;
- role-level ownership and escalation contracts;
- recurring operating cadence and handover quality;
- machine-readable context routing for agents.

Run `node tools/validate-marketing-operations-context.js` after changing a
system ID, integration ID, gap ID, scenario ID or canonical context path.

## This Workstream Does Not Own

- live campaign budgets, bidding or activation;
- GTM, GA4, Google Ads or Meta writes;
- plugin/runtime implementation details;
- SEO recommendations;
- school/program source data;
- production Cloud/Stape deployment;
- CRM business-process decisions.

Those remain with the narrow owner and require the approvals defined there.

## Current Gaps In Growth Operations

- Named role-level RACI is incomplete.
- Reporting, optimization, data-quality and incident cadences are not yet a
  single approved calendar.
- Vendor response and escalation SLAs are not documented.
- Campaign intake-to-postmortem SOP remains distributed across naming,
  paid-media and budget documents.
- Access recovery and production ownership for Stape/private runtime remain
  pending.
- The BI-owned Supabase Parent outcome model, identifiers, history, freshness,
  and pipeline behavior remain pending read-only verification and a versioned
  interface contract.
- Creative assets, partner offers, organic social, agency access, experiments
  and broader brand/content approvals do not yet have complete central
  registers.

## New Document Rule

Add a document here only when it crosses at least two workstreams. Put
platform-specific or implementation-specific detail in the narrow owning
folder and link to it.
