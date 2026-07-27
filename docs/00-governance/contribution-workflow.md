# Contribution Workflow

Last updated: 2026-07-27

## Before Adding A File

1. Read the
   [marketing operations context layer](./marketing-operations-context-layer.md).
2. Read [repo-map.md](./repo-map.md).
3. Read the [measurement platform handover](./measurement-platform-handover-2026-07-27.md)
   and [growth operations register](../70-growth-operations/README.md) when the
   change crosses workstreams.
4. Choose the narrowest workstream folder.
5. Check whether a workstream README already links the relevant current file.
6. If the update affects live tracking, platform configuration, or
   source-of-truth data, verify the current state first.

## File Naming

Use this pattern for dated operational docs:

```text
topic-name-YYYY-MM-DD.md
```

Use stable names for indexes and evergreen docs:

```text
README.md
event-taxonomy.md
source-of-truth-rules.md
```

## Required Sections For Handoffs

Use [workstream-update-template.md](../_templates/workstream-update-template.md) for larger updates.

Minimum sections:

- Purpose
- Current verified status
- Source evidence
- Decisions
- Open questions
- Next actions

## Commit Rules

- Documentation-only changes should not include plugin runtime edits unless the task explicitly covers both.
- Runtime plugin edits should include verification notes in the same PR/commit or an adjacent doc update.
- Do not commit local secrets, auth files, raw logs, or full platform exports.
- This repository is public. Do not commit PII, raw CRM/form payloads,
  private browser sessions, or CEFA-only cloud runtime.
- Record private-runtime changes here only as redacted contracts, release
  references, aggregate QA, and current status.
