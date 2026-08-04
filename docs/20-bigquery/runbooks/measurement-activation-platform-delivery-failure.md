# Measurement Activation Platform Delivery Failure - Runbook

**Severity:** P1 for active production delivery; P2 in validate-only/test mode
**On-call owner:** CEFA marketing measurement
**Last tested:** Pending synthetic test
**Review cadence:** Quarterly and after every incident

## Detection

Trigger this runbook when:

- `google_delivery_status` or `meta_delivery_status` is red;
- retryable failures or queued rows exceed the amber threshold;
- Google diagnostics report permanent rejection;
- Meta returns a delivery error or expected receipt is absent;
- destination account/action/event isolation is uncertain.

Request acceptance alone is not success. Use final Google diagnostics and the
recorded Meta receipt/error state.

## Immediate Actions

1. Disable only the affected platform sender when destination isolation is
   proven.
2. Activate the global dispatcher kill switch when cross-platform identity,
   stage, school or transaction integrity is uncertain.
3. Preserve the outbox row, transaction ID, request ID and redacted attempt
   history.
4. Do not create a replacement event or transaction ID.
5. Keep website inquiry conversions and the unaffected platform route live
   unless a global stop condition exists.

## Diagnosis

1. Confirm the destination account, action/event name and runtime mode.
2. Inspect the bounded platform error code and final diagnostic status.
3. Check credential validity, account access, quota and API availability.
4. Check event age, timestamp, match eligibility and required parameters.
5. Verify the record is not baseline, test, quarantined or already accepted.
6. Check whether the failure is retryable or permanent.

## Resolution

### Google

1. Correct access, schema or eligibility without changing the transaction ID.
2. Run `validateOnly=true` for the affected destination.
3. Retry through the existing outbox only after validation passes.
4. Retrieve final Data Manager diagnostics.
5. Use a documented Google correction workflow only when correction support
   and transaction identity have been tested.

### Meta

1. Correct access, schema or eligibility without changing `event_id`.
2. Verify the event in Test Events when the failure can be reproduced safely.
3. Retry through the existing outbox only when the original event was not
   accepted.
4. Do not fabricate `fbc`, `fbp`, click timestamps or a correction receipt.

## Success Criteria

- The affected platform shows final accepted delivery or an explicitly closed
  permanent rejection.
- No duplicate event was created.
- The other platform and existing inquiry conversion path remained unchanged.
- Backlog and retry age return within threshold.
- Recovery evidence is dated in the implementation report.

## Escalation

| Condition | Escalate to | Response |
|---|---|---|
| Google/Meta account access changed | Platform administrator | Restore approved least-privilege access |
| API outage or quota incident | Platform support/Cloud owner | Keep outbox queued; retry after recovery |
| Destination or event mapping uncertain | Marketing measurement owner | Keep sender off until read-back is verified |
| Duplicate or wrong-stage event accepted | Marketing measurement owner | Activate global kill switch and reconcile platform impact |
