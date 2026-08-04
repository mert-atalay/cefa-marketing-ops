# Parent Identity And Measurement Completion

**Date:** 2026-08-04  
**Scope:** Parent `cefa.ca` only  
**Status:** Implemented with guarded destination and business-outcome gates

## Completed

1. Parent CEFA Conversion Tracking `0.6.4` is live. After one successful Form
   `4` conversion, the browser creates a new UUID for the next submission while
   retaining one UUID through validation retries.
2. The server-reserved Parent event identity remains unchanged and unique. At
   the deployment checkpoint, `2,370` shadow-era entries had a reserved server
   ID and none of those IDs was duplicated.
3. Existing Gravity Forms, School Manager, KinderTales, attribution fields,
   browser Google/Meta destinations and campaign goals were not changed.
4. A controlled GET-only production check returned HTTP `200`, served plugin
   `0.6.4`, and created no Form `4` entry or KinderTales delivery.
5. The certified reporting package now includes event, daily, daily-QA,
   measurement-dictionary and two candidate dashboard views. It contains no
   direct PII and does not replace existing dashboard contracts.
6. The Dataform cloud workspace mirrors the `18` Git assertions. The workspace
   is committed, compiles without errors, and the full cloud run passed
   `18/18`.
7. Stape has enabled hourly incoming `5xx`, outgoing `4xx`, and outgoing `5xx`
   rules plus one enabled alert recipient. Meta returned HTTP `200`,
   `events_received=1`, and no messages for all three inspected server sends.
8. The restricted BigQuery
   `cefa_parent_activation_restricted.parent_business_outcome_inbox` exists at
   zero rows. It is the fail-closed landing contract for a future BI Supabase
   outcome feed and stores only governed IDs/HMAC keys, outcome semantics,
   lineage and timestamps.

## Acceptance Evidence

- Parent JavaScript identity regression test: pass.
- Parent and franchise PHP tests: pass.
- PHP syntax checks: pass.
- Composer package validation and PHP test script: pass.
- WordPress/PHP compatibility code standards (PHPCS): pass.
- BigQuery DDL dry run: pass; outcome inbox deployed with zero rows.
- Certified-report SQL dry run and live read-back: pass.
- Dataform cloud assertions: `18/18` pass.
- Production plugin read-back and non-conversion check: pass.

## Still Gated

- Meta Events Manager must prove browser/server pair deduplication; Stape and
  Meta acceptance alone do not prove the merge.
- Google server inquiry delivery remains paused until one controlled saved
  Form `4` test proves one accepted Google conversion.
- The BI Supabase feed remains empty until BI provides read-only schema and
  pipeline evidence and maps the v1 contract.
- Parent CRM/offline dispatch remains fail-closed until GreenRope/KinderTales
  preserve `cefa_event_id` and `cefa_form_entry_id` and the controlled identity
  read-back passes.
- Candidate reporting views require dashboard-owner QA before promotion.
- Production Dataform scheduling requires the governed Git/runtime release
  path; Cloud Run remains the production orchestrator.

## Rollback

- Plugin source and the pre-release package version remain available in Git;
  use the normal WordPress release process to redeploy a reviewed prior build.
- Server GTM version `8` pauses Parent Meta CAPI while retaining guarded GA4.
- Google server tags remain paused, so no Google rollback is required.
- BigQuery additions are empty/additive and are not referenced by existing
  dashboard contracts or dispatch schedules.
