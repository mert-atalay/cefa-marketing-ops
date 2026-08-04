# Measurement Activation Pipeline Failure - Runbook

**Severity:** P1 when an active production route misses its red freshness threshold; P2 before activation
**On-call owner:** CEFA marketing measurement
**Last tested:** Pending synthetic test
**Review cadence:** Quarterly and after every incident

## Detection

Use `cefa_ops.vw_measurement_activation_health_v1`.

Trigger this runbook when:

- `last_successful_sync` is red;
- the latest run status is failed;
- the pipeline completed but source freshness did not advance;
- Cloud Scheduler or Cloud Run reports a failed execution.

## Immediate Actions

1. Identify the affected `site_context` and `pipeline_key`.
2. Confirm whether the route is active, guarded, paused, or planned.
3. Stop only the affected downstream writer or dispatcher when partial output
   is possible.
4. Keep Gravity Forms, KinderTales, Synuma/SiteZeus and existing website
   conversions live.
5. Preserve the run record, lifecycle ledger, outbox and delivery attempts.

Activate the global dispatcher kill switch only when the failure may have
produced duplicates, wrong stages, baseline uploads, destination cross-talk or
PII exposure.

## Diagnosis

1. Check the latest Cloud Scheduler execution.
2. Check the matching Cloud Run job execution and bounded error code.
3. Verify source authentication, quota and endpoint availability.
4. Verify BigQuery write permission and schema compatibility.
5. Compare the latest successful run timestamp with the latest source-event
   timestamp.
6. If only a platform upload failed, switch to the platform-delivery runbook.
7. If counts do not reconcile, switch to the data-quality runbook.

## Resolution

1. Correct the source, authentication, schema or runtime issue.
2. Rerun first in disabled, dry-run, validate-only or test mode as applicable.
3. Confirm `read = loaded + quarantined + rejected`.
4. Replay only through the existing idempotent key and outbox path.
5. Confirm source freshness advances and no duplicate transaction appears.
6. Re-enable only the affected route.

## Success Criteria

- A new successful run is visible.
- Source freshness is within threshold.
- Reconciliation difference equals `0`.
- No accepted duplicate, PII leak, baseline upload or business-delivery
  regression occurred.
- The incident and recovery evidence are dated in the implementation report.

## Escalation

| Condition | Escalate to | Response |
|---|---|---|
| Source or Supabase endpoint unavailable | Source/BI owner | Keep downstream route paused; request source restoration |
| KinderTales, GreenRope or Synuma delivery affected | Business-system owner | Protect business delivery first; keep marketing sender off |
| IAM, network or runtime failure | CEFA IT/Cloud owner | Restore least-privilege access; do not broaden access as a shortcut |
| Duplicate, PII, baseline or wrong-stage risk | Marketing measurement owner and IT/privacy as applicable | Activate global kill switch and preserve evidence |
