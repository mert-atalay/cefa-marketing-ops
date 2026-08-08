# CEFA Marketing Operations Hub Instructions

This repository is the public CEFA Marketing Operations Hub. It has three
responsibilities:

1. Runtime code for the `CEFA Conversion Tracking` WordPress plugin.
2. Governed documentation for CEFA marketing operations workstreams.
3. Non-secret reference contracts, collectors, tests and warehouse QA packages.

Keep those responsibilities separate.

## Repo Boundaries

- Runtime plugin code lives in the root PHP file, `includes/`, `assets/`, `snippets/`, and release files.
- Workstream documentation lives under numbered folders in `docs/`.
- Reusable reference data should live under `data/reference/`.
- Do not put scratch notes, raw exports, secrets, OAuth tokens, platform credentials, or large temporary files in this repo.
- Do not change live GTM, GA4, Google Ads, Meta, WordPress, or BigQuery settings unless the user explicitly asks for live execution.

## Workstream Map

- `docs/10-conversion-tracking/`: parent, franchise Canada, franchise USA, GTM, GA4, Ads/Meta conversion contracts, CAPI, sGTM, Measurement Protocol.
- `docs/20-bigquery/`: datasets, marts, schemas, QA checks, offline conversion exports, reporting data contracts.
- `docs/30-seo/`: technical SEO, local SEO, Search Console, sitemap/page taxonomy, SEO measurement.
- `docs/40-naming-convention/`: CEFA Meta naming convention, creative filenames, UTM conventions, n8n naming guardrails.
- `docs/50-paid-media/`: ad account structure, launch QA, optimization notes, platform conversion action status, budget-safety references.
- `docs/60-master-data/`: schools, programs, locations, CRM/system crosswalks, canonical reference tables.
- `docs/70-growth-operations/`: cross-system integrations, dependencies,
  gaps, risks, scenarios, RACI and operating cadence.
- `docs/00-governance/`: source-of-truth rules, agent responsibilities, repo map, and contribution workflow.

## Agent Rules

- Start at
  `docs/00-governance/marketing-operations-context-layer.md`.
- Read
  `docs/70-growth-operations/system-and-integration-register.md` and
  `docs/70-growth-operations/gap-risk-and-scenario-register.md` when a task
  crosses systems or workstreams.
- Continue to
  `docs/00-governance/measurement-platform-handover-2026-07-27.md`.
- Use `docs/00-governance/measurement-and-activation-program-register-2026-07-23.md`
  for current status, blockers, and sequencing.
- Use `docs/00-governance/parent-omnichannel-measurement-and-intelligence-roadmap-2026-08-08.md`
  for the current Parent execution sequence across source correctness,
  freshness, sGTM operations, CRM outcomes, offline activation, creative
  intelligence, forecasting, lead scoring and MMM.
- Use `docs/superpowers/plans/2026-07-25-google-cloud-stape-measurement-platform-blueprint.md`
  for definitive implementation architecture and
  `docs/superpowers/plans/2026-06-12-bq-marketing-intelligence-blueprint.md`
  for the locked strategic BigQuery direction.
- Read `docs/00-governance/repo-map.md` before adding new documentation.
- Update the relevant workstream `README.md` when adding or changing docs in that workstream.
- If a decision affects more than one workstream, update `docs/00-governance/source-of-truth-rules.md` or add a cross-link from the relevant workstream README.
- Keep parent `cefa.ca`, franchise Canada `franchise.cefa.ca`, and franchise USA `www.franchisecefa.com` separate unless the document is explicitly cross-property.
- Parent `cefa.ca` Form `4` is delivered to KinderTales by CEFA School Manager and uses attribution fields `35-46`. Synuma/SiteZeus is franchise-only; never describe it as the parent CRM path.
- For conversion tracking, `school_uuid` is the parent school join key unless a future verified source changes that.
- Do not promote assumptions into verified sections. Use the status vocabulary
  in `docs/00-governance/source-of-truth-rules.md`.
- If a file is mainly a source index or handoff for another agent, say that directly in the file.
- This repository is public. Never commit credentials, raw CRM/form/platform
  payloads, PII, browser sessions, private exports, or CEFA-only production
  runtime.
- Private Cloud Run, Dataform, infrastructure, Stape, GTM, deployment, and
  runbook source belongs in the planned CEFA-controlled private runtime
  repository.

## Commit Hygiene

- Keep runtime plugin changes and documentation-only changes in separate commits when practical.
- Do not commit generated ZIPs unless the user explicitly asks for a release package to be tracked.
- Do not rewrite another agent's work without reading it first.
