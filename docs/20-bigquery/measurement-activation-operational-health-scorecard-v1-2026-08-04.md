# Measurement Activation Operational Health Scorecard V1

**Date:** 2026-08-04
**Version:** 1.0
**Owner:** CEFA marketing measurement
**Status:** Additive BigQuery baseline deployed; runtime instrumentation pending
**Review cadence:** Weekly during guarded rollout; monthly after stabilization

## Purpose

Provide the smallest operational control surface needed to run CEFA's
measurement and secondary outcome activation safely. This implements Rafael's
recommended baseline without creating a broad governance program or delaying
the existing attribution, GA4, Stape, BigQuery, or website-conversion work.

The scorecard is aggregate-only. It must never expose event IDs, form entry
IDs, contact hashes, click IDs, parent or child data, raw payloads, or free-text
platform errors.

## Scope

V1 covers:

- Parent Form 4 capture and identity preparation;
- Parent lifecycle polling and secondary Google/Meta delivery when activated;
- explicit `NOT_ACTIVE` placeholders for guarded or future Parent, Franchise
  Canada, and Franchise USA outcome routes;
- one per-run reconciliation equation;
- one short response runbook for each major failure class.

V1 does not enable a poller, dispatcher, platform send, campaign goal,
conversion action, GTM route, CRM feed, or website event. Existing Form 4,
KinderTales, franchise Synuma/SiteZeus, Google Ads, Meta, GA4, and website
conversions remain unchanged.

## Scorecard Contract

| Metric | V1 definition | Initial threshold | Owner | Breach action |
|---|---|---|---|---|
| Last successful synchronization | Latest successful run and latest source-event timestamp, by site context and pipeline | Green within `1.25x` cadence; amber within `1.5x`; red after that; inactive routes are `NOT_ACTIVE` | CEFA marketing measurement | Pipeline-failure runbook |
| Records reconciled | `records_read = records_loaded + records_quarantined + records_rejected` for the latest run | Difference must equal `0` | CEFA marketing measurement | Data-quality runbook; no replay until zero |
| Missing CEFA IDs | Prospective, non-baseline lifecycle records missing exact event or form-entry identity | Green `0`; amber only when every affected row is quarantined; red if any unsafe row escapes quarantine | CEFA marketing measurement | Quarantine affected rows; verify identity contract |
| Duplicate transactions | Duplicate outbox transaction groups; delivery retries are not duplicates | Green `0`; any accepted duplicate is an immediate stop | CEFA marketing measurement | Global dispatcher kill switch and data-quality runbook |
| Google delivery | Final outbox/diagnostic status, not only HTTP request acceptance | Red for permanent failure or processing older than 24 hours; amber for retryable failure or stale queue | CEFA marketing measurement | Google branch of platform runbook |
| Meta delivery | Final outbox status and CAPI receipt evidence | Same initial threshold as Google; no fabricated receipt or correction | CEFA marketing measurement | Meta branch of platform runbook |
| Records currently in quarantine | Actionable identity/lifecycle quarantines; baseline, tests, known non-uploadable stages and dedup guards are excluded | Green `0`; amber when contained under 7 days; red when oldest actionable row exceeds 7 days | CEFA marketing measurement | Data-quality runbook; reason-by-reason resolution |

Thresholds are V1 operating defaults, not permanent KPI definitions. Change a
threshold only through a versioned code/document update with a dated reason.

## BigQuery Objects

Source-controlled implementation:

```text
tools/warehouse/measurement_activation_operational_health_v1.sql
```

It creates only:

- `cefa_ops.measurement_pipeline_run_v1`: aggregate run counts and timestamps;
- `cefa_ops.vw_measurement_activation_health_v1`: aggregate scorecard rows.

Both objects were deployed and read back on 2026-08-04. The first live read
correctly returned inactive lifecycle/platform routes as `NOT_ACTIVE`, the
active capture route as `NOT_INSTRUMENTED` until per-run totals are written,
and six existing `unknown_school_uuid` identity quarantines as an actionable
red condition. It did not enable any sender.

Every instrumented runtime writes one terminal run record. It must use a safe
opaque `run_id`, a governed pipeline/site key, counts, timestamps, status and a
bounded machine-readable error code. It must not store a source-record ID,
event ID, lead ID, payload or free-text error.

## Current Evidence Boundary

The existing restricted Parent activation foundation already provides:

- HMAC-only Form 4 identity state;
- lifecycle snapshots and prospective event quarantine;
- deterministic transaction IDs and accepted locks;
- idempotent Google/Meta outbox state;
- redacted platform delivery attempts and Google diagnostics;
- platform and global kill switches.

The new run table fills the remaining reconciliation gap. Until a runtime is
instrumented, its run-based metrics show `NOT_INSTRUMENTED`. A deliberately
paused or future route shows `NOT_ACTIVE`; neither is reported as a false
production failure.

## Controlled Test Matrix

| Test | Expected result |
|---|---|
| Successful synthetic run | Freshness green and reconciliation difference `0` |
| Run with `read != loaded + quarantined + rejected` | Reconciliation red; no replay permitted |
| Missing CEFA identity | Only affected record quarantined; missing-ID metric amber, never sent |
| Duplicate outbox transaction | Duplicate metric red; dispatcher kill switch activated |
| Retry of the same platform transaction | Same transaction ID retained; not counted as a duplicate transaction |
| Google permanent diagnostic failure | Google red; Google path stopped; Meta unaffected if isolation is proven |
| Meta delivery failure | Meta red; Meta path stopped; Google unaffected if isolation is proven |
| Disabled route | `NOT_ACTIVE`, not red |
| Synthetic baseline/test row | Excluded from actionable quarantine and never delivered |

## Promotion Gate

This package does not add a calendar waiting period. Before secondary outcome
delivery is enabled for a route:

1. Instrument that runtime to append one aggregate run record.
2. Run its synthetic success, reconciliation-failure and kill-switch tests.
3. Confirm the scorecard exposes no prohibited data.
4. Confirm the applicable runbooks can be executed by someone other than the
   original implementer.
5. Record the evidence in the activation implementation report.

The controls are built in parallel with identity/vendor work. They delay only
an unsafe production send, not the broader measurement project.

## Runbooks

- [Pipeline failure](./runbooks/measurement-activation-pipeline-failure.md)
- [Data-quality failure](./runbooks/measurement-activation-data-quality-failure.md)
- [Platform delivery failure](./runbooks/measurement-activation-platform-delivery-failure.md)
