# Governance

This folder defines how the CEFA Marketing Operations Hub is organized.

Start here when adding a new document, routing work to another agent, or deciding where a new source-of-truth update belongs.

## Files

- [marketing-operations-context-layer.md](./marketing-operations-context-layer.md):
  canonical first read for business domains, systems, authority, identifiers,
  activation rules, known blanks and decision routing.
- [measurement-platform-handover-2026-07-27.md](./measurement-platform-handover-2026-07-27.md):
  one-document handover covering ownership, live flows, identifiers, plugins,
  BigQuery/Stape structure, naming, blockers, roadmap, and the public/private
  source-control boundary.
- [repository-rename-2026-07-27.md](./repository-rename-2026-07-27.md): why
  the GitHub hub is named `cefa-marketing-ops`, what changed, and which
  component names remain unchanged.
- [measurement-and-activation-program-register-2026-07-23.md](./measurement-and-activation-program-register-2026-07-23.md): cross-workstream status, approved tooling, blockers, parallel build lanes, and production gates for conversion tracking, Stape sGTM, BigQuery/Dataform, and offline activation.
- [parent-omnichannel-measurement-and-intelligence-roadmap-2026-08-08.md](./parent-omnichannel-measurement-and-intelligence-roadmap-2026-08-08.md): canonical current Parent roadmap covering measurement correctness, data productionization, CRM outcomes, offline activation, creative analysis, trained modeling, MMM readiness and controlled use.
- [Marketing and BI alignment final decision](../70-growth-operations/marketing-bi-alignment-final-decision-and-email-2026-07-27.md): approved Supabase/BigQuery boundary, independent Track A/Track B promotion gates, meeting outcomes, and send-ready stakeholder email.
- [repo-map.md](./repo-map.md): folder map, workstream boundaries, and where each agent should write.
- [source-of-truth-rules.md](./source-of-truth-rules.md): authority order and verification rules.
- [data-taxonomy.md](./data-taxonomy.md): cross-workstream map of CEFA data sources, stable IDs, naming keys, conversion events, warehouse surfaces, and owning docs.
- [Growth operations register](../70-growth-operations/README.md): system
  integrations, gaps, risks, what-if scenarios and cross-workstream ownership.
- [repository-structure-audit-2026-06-03.md](./repository-structure-audit-2026-06-03.md): current repo/branch structure audit, collision risks, and branch consolidation recommendation.
- [codex-machine-migration-checklist-2026-06-04.md](./codex-machine-migration-checklist-2026-06-04.md): non-secret checklist for carrying Codex config, memory, MCPs, plugins, local workspaces, and auth surfaces to a new Mac.
- [agent-responsibilities.md](./agent-responsibilities.md): agent/workstream ownership boundaries.
- [contribution-workflow.md](./contribution-workflow.md): how to add docs without mixing workstreams.

## Core Rule

Use this repo as the shared reference layer, but keep facts in the narrowest correct location. Runtime plugin code, tracking plans, BigQuery contracts, SEO notes, naming rules, and paid-media execution notes should not be mixed into one file.

This repository is public. The governed handover belongs here; credentials,
PII, raw payloads, private exports, and CEFA-only cloud runtime do not.
