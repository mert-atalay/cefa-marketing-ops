# Measurement Activation Data-Quality Failure - Runbook

**Severity:** P0 for PII leakage or accepted duplicates; P1 for unresolved reconciliation/identity failures
**On-call owner:** CEFA marketing measurement
**Last tested:** Pending synthetic test
**Review cadence:** Quarterly and after every incident

## Detection

Trigger this runbook when:

- `records_reconciled` is red;
- `missing_cefa_ids` is amber or red;
- `duplicate_transactions` is red;
- actionable quarantine is red or growing unexpectedly;
- an initial baseline, wrong stage, wrong school or test row becomes eligible;
- a prohibited field or value appears in BigQuery, logs or diagnostics.

## Immediate Actions

1. Activate the global dispatcher kill switch for an accepted duplicate, PII
   leak, baseline upload, wrong stage, wrong school or destination cross-talk.
2. Otherwise, stop only the affected route.
3. Preserve source rows, run counts, quarantine reasons, outbox state and
   delivery evidence.
4. Do not delete, overwrite, relabel or manually manufacture an identity.
5. Keep unaffected website conversions and business delivery live.

## Diagnosis

1. Recalculate `records_read - records_loaded - records_quarantined - records_rejected`.
2. Identify the first run where the difference became nonzero.
3. Check exact `cefa_event_id` and form-entry identity at the restricted
   boundary without exposing them in the scorecard or incident notes.
4. Check school UUID and stage mapping versions.
5. Check whether an apparent duplicate is only a retry using the same
   transaction ID.
6. Check accepted locks before considering any replay.
7. Classify every quarantine reason as recoverable, expected control behavior
   or permanent rejection.

## Resolution

1. Correct the mapping, schema, identity handoff or deduplication rule in
   source-controlled code.
2. Keep incomplete or ambiguous records quarantined.
3. Rerun the affected batch in dry-run or validate-only mode.
4. Confirm the reconciliation difference returns to `0`.
5. Confirm duplicate transaction groups equal `0`.
6. Release recoverable quarantine rows through the same deterministic outbox
   identity.
7. Re-enable only after the controlled test passes.

## Success Criteria

- Reconciliation difference equals `0`.
- Accepted duplicate transaction IDs equal `0`.
- Every missing or conflicting identity remains blocked.
- No raw PII appears in monitoring, logs, tables or diagnostics.
- Existing Form 4, KinderTales, Synuma/SiteZeus and inquiry conversions remain
  unchanged.

## Escalation

| Condition | Escalate to | Response |
|---|---|---|
| Exact identity absent in source system | KinderTales/GreenRope or BI owner | Keep affected records quarantined; repair the contract |
| School or stage mapping ambiguous | Marketing measurement and business owner | Approve one governed mapping before replay |
| Raw PII detected | CEFA IT/privacy owner | Stop sender, restrict access and follow CEFA incident procedure |
| Accepted duplicate detected | Marketing measurement owner | Keep global kill switch on until platform impact is reconciled |
