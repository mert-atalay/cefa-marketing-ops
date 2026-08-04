# CEFA Gap, Risk And Scenario Register

**Last updated:** 2026-07-27
**Owner:** CEFA marketing operations
**Status:** Canonical cross-workstream risk and what-if register
**Review cadence:** Weekly for active alerts; monthly for all other items

## Severity

| Severity | Meaning |
|---|---|
| `Critical` | Active risk of data loss, duplicate spend/conversions, privacy exposure or broken business delivery |
| `High` | Blocks an approved outcome or materially weakens decisions |
| `Medium` | Creates operational ambiguity, manual work or limited coverage |
| `Low` | Improvement or cleanup with limited current business impact |

## Open Gaps And Risks

| Gap ID | Gap / risk | Severity | Status | Owner role | Completion evidence |
|---|---|---|---|---|---|
| `GAP-001` | CEFA private runtime repository does not exist | `High` | `Blocked` | Cloud/data engineering | Reproducible private source, access, CI, release and rollback exist |
| `GAP-002` | GreenRope lacks confirmed exact Form 4 event and entry fields | `High` | `Blocked` | GreenRope/KinderTales vendor owner | Both fields exist, round-trip through API and match a controlled inquiry |
| `GAP-003` | KinderTales-to-GreenRope opportunity creation path is not confirmed | `High` | `Open question` | Parent operations/vendor owner | Documented endpoint/workflow, keys, retry and deduplication behavior |
| `GAP-004` | Parent GA4 production routing and shared dedup identity are live, but natural-event parity, controlled Google/Meta server deduplication, consent-state operations, rollback signoff and franchise isolation are incomplete | `High` | `Active guarded` | Cloud/Stape owner | Next legitimate Parent event and controlled destination tests pass, then isolated Canada and USA builds pass |
| `GAP-005` | Dataform production Git, runtime identity, release and workflow configs are incomplete | `High` | `Pending` | BigQuery/data owner | Parallel parity, assertions, schedule and rollback pass |
| `GAP-006` | Franchise GAConnector replacement evidence remains below cutover gate | `High` | `Active guarded` | Conversion tracking owner | Coverage/parity, field mapping and rollback meet approved gate |
| `GAP-007` | Recent USA Form 1 entries lack Synuma lead IDs | `High` | `Partial` | Franchise delivery owner | Delivery cause resolved and prospective entries reconcile |
| `GAP-008` | Parent Mailchimp Form 4 feed purpose and mapped fields need review | `High` | `Pending` | Website/email owner | Feed inventory, approved purpose, minimized mapping and tests documented |
| `GAP-009` | Parent Zoho CRM and webhook feed ownership is unknown | `Medium` | `Open question` | Website/CRM owner | Active feeds, destinations, purpose and owner are documented |
| `GAP-010` | School/program/CRM/listing crosswalks remain incomplete | `High` | `Partial` | Master-data owner | All active entities map to `school_uuid` with uniqueness assertions |
| `GAP-011` | Paid connector/detail freshness is stale in the checked reporting state | `High` | `Partial` | Paid-media/data owner | Current Google/Meta detail reconciles to platform totals |
| `GAP-012` | Search Console and DataForSEO evidence needs a current refresh | `Medium` | `Partial` | SEO owner | Dated refresh and reconciled page/query scope |
| `GAP-013` | NC2/GADS1 remain candidate conventions and inventories are dated | `Medium` | `Pending` | Naming/paid owner | Fresh inventory and explicit migration approval |
| `GAP-014` | n8n validation/export/audit workflow is not operational | `Low` | `Pending` | Automation owner | Versioned dry-run output and approval gates pass |
| `GAP-015` | Source-confirmed household/dependent identity is unavailable | `Medium` | `Pending` | KinderTales/master-data owner | Stable source IDs and multi-child tests pass |
| `GAP-016` | Cloud monitoring, alerting, dead-letter handling and runbooks are incomplete | `High` | `Partial` | Cloud runtime owner | Tested alerts, queues, replay and on-call runbooks |
| `GAP-017` | Growth operations RACI and recurring operating calendar are incomplete | `Medium` | `Pending` | Marketing operations owner | Approved roles, SLAs and meeting/reporting cadence |
| `GAP-018` | Current dashboards do not all expose consistent grain/source/freshness labels | `Medium` | `Partial` | Reporting owner | Every promoted dashboard surface declares all three |
| `GAP-019` | Creative asset ownership, version, approval and usage-right evidence is not centralized | `Medium` | `Partial` | Creative/marketing owner | Approved asset registry maps files to campaigns and expiry/rights |
| `GAP-020` | Partner, merchant-page and offer inventory is not centralized | `Medium` | `Pending` | Partnerships/marketing owner | Every live placement has owner, dates, offer, URL, UTM and reporting key |
| `GAP-021` | Organic social/content calendar and attribution contract are not documented | `Medium` | `Open question` | Content/social owner | Platforms, owners, calendar, URLs and measurement rules are approved |
| `GAP-022` | Agency/vendor access ownership, offboarding and escalation SLAs are incomplete | `High` | `Pending` | Marketing operations owner | Current roster, access owner, backup, SLA and removal procedure |
| `GAP-023` | Campaign experiment and postmortem history is not a governed central register | `Medium` | `Pending` | Marketing operations owner | Every material test records hypothesis, split, result and decision |
| `GAP-024` | Budget-plan-to-platform reconciliation lacks one approved recurring cadence | `High` | `Pending` | Budget/paid owner | Monthly plan, live budget, spend and forecast reconcile with sign-off |
| `GAP-025` | Full marketing KPI glossary and target ownership are incomplete | `Medium` | `Partial` | BI and marketing intelligence owners | Shared dictionary gives each KPI one definition, grain, source, window, target, owner and reconciliation rule |
| `GAP-026` | Brand/content approval rules outside paid-ad copy are not centralized | `Medium` | `Pending` | Brand/content owner | Governed voice, claims, approval and channel adaptation contract |
| `GAP-027` | BI Supabase Parent outcome grain, identity, history, lineage and freshness are not verified for marketing use | `High` | `Pending` | BI and marketing data owners | Read-only schema/pipeline inspection, proof-of-concept record, versioned contract, parity and rollback pass |

## What-If Playbook

### `SCN-001`: Platform conversions exceed saved inquiries

**Trigger:** Google or Meta reports materially more final conversions than
Gravity Forms/business records.

1. Stop optimization or budget decisions based on the suspect conversion.
2. Compare event IDs and transaction IDs for duplicates.
3. Check GTM, plugin, WPCode and add-on ownership for competing final events.
4. Compare promoted school, selected school and form destination separately.
5. Restore only the verified once-only path.

Do not explain the gap as cannibalization until selected-school evidence
supports it.

### `SCN-002`: Saved inquiries exist but platforms report no conversions

1. Confirm the saved entry and business delivery first.
2. Trace the neutral event, event ID, GTM/sGTM route and destination receipt.
3. Check campaign goal selection and primary/secondary status.
4. Check identifier age and platform diagnostics.
5. Preserve the business record even if the platform is blind.

Do not conclude that acquisition stopped because a platform tag failed.

### `SCN-003`: UTMs are missing

1. Check valid `gclid`, `gbraid`, `wbraid`, `fbclid` or `msclkid`.
2. Check first-party canonical attribution and landing/referrer evidence.
3. Check platform object/click evidence and the last non-direct rule.
4. Mark the record unknown when evidence remains insufficient.

Do not classify all no-UTM traffic as direct and do not manufacture click IDs.

### `SCN-004`: Safari, ad blocking or browser loss is suspected

1. Use saved form/business evidence as lead truth.
2. Compare first-party server ledger and browser evidence.
3. Use Stape/server transport only after deduplication gates pass.
4. Report match coverage honestly.

Server-side tagging improves resilience; it does not recover identifiers that
were never collected.

### `SCN-005`: Promoted school differs from selected school

1. Keep `promoted_school_uuid` and `selected_school_uuid` as separate fields.
2. Report assisted/cross-school behavior separately from selected-school
   conversion.
3. Check landing page, school search and inquiry-selection journey.

Do not overwrite selected school with campaign school.

### `SCN-006`: Campaign targets the wrong region, age or URL

1. Pause the affected campaign/object.
2. Verify geo settings, age/program contract, final URL and UTM output.
3. Verify the correct conversion goal.
4. Correct and revalidate before reactivation.

Do not retag historical leads to hide a targeting error.

### `SCN-007`: Franchise lead has no Synuma ID

1. Treat business delivery as unconfirmed.
2. Preserve the form entry and event identity.
3. Review delivery response/status without resubmitting blindly.
4. Escalate to the franchise delivery owner.
5. Exclude the record from CRM-delivered lead truth until reconciled.

### `SCN-008`: CRM rejects an inactive sales owner

1. Preserve the website/form submission.
2. Capture the vendor error without exposing PII.
3. Route the lead through approved CRM assignment configuration.
4. Remove hard-coded owner/region only after business-owner approval.
5. Retry idempotently.

### `SCN-009`: GAConnector and CEFA attribution disagree

1. Keep both evidence sets.
2. Compare current touch, first touch, click IDs and mismatch keys.
3. Mark direct placeholders separately from real capture failures.
4. Keep GAConnector active until the cutover gate is approved.

Do not overwrite legacy fields during shadow comparison.

### `SCN-010`: Stape browser/server copies duplicate conversions

1. Disable the property-specific server dispatcher/route.
2. Preserve logs and event IDs.
3. Verify browser/server copies share one event ID and destination dedupe key.
4. Restore only after a controlled test passes.

Do not disable the website form or business-delivery path.

### `SCN-011`: Offline CRM conversions duplicate or map the wrong stage

1. Activate the dispatcher kill switch.
2. Preserve the lifecycle ledger and delivery log.
3. Check transaction-ID stability, baseline flags and canonical stage mapping.
4. Quarantine affected records.
5. Keep website inquiry conversions unchanged.

### `SCN-012`: Data source or dashboard is stale

1. Show the last successful source date.
2. Label the affected metric partial or stale.
3. Compare against the live source read-only.
4. Repair the source job before promoting the dashboard result.

Do not silently carry forward the last value.

### `SCN-013`: Two systems disagree

1. Use the
   [source-of-truth hierarchy](../00-governance/source-of-truth-rules.md).
2. Compare grain, timezone, deduplication, attribution window and freshness.
3. Preserve both raw facts and document the reconciliation rule.
4. Escalate if the business-truth source is itself uncertain.

### `SCN-014`: Multiple children, schools or opportunities share a parent

1. Keep adult, household, dependent, inquiry, opportunity and school grains
   separate.
2. Deduplicate platform activation by the approved event/stage contract.
3. Preserve legitimate multiple inquiries and school interests.

Do not deduplicate by email alone.

### `SCN-015`: Agency-test conversion does not appear

1. Confirm the campaign URL carries the governed agency marker.
2. Confirm the marker persists until the real final lead event.
3. Confirm Pixel/CAPI carry the same custom parameter and event ID.
4. Confirm the Meta custom conversion filters the standard final event.
5. If volume is low, optimize both campaigns to the shared standard event and
   use agency custom conversions for reporting.

### `SCN-016`: Visible ad copy violates the CEFA Early Years rule

1. Keep the object paused or pause the affected live ad.
2. Replace prohibited visible category terms with `CEFA Early Years` or
   `CEFA Early Years School`.
3. Re-run location, age, URL and conversion QA.

Targeting keywords may still use approved category-intent terms.

### `SCN-017`: PII or a credential appears in the public repository

1. Stop further distribution.
2. Revoke or rotate the exposed credential immediately.
3. Remove the data from the current tree and coordinate Git-history cleanup.
4. Audit access and logs.
5. Move required private source to approved restricted storage.

### `SCN-018`: Private runtime source is unavailable

1. Leave current production services unchanged.
2. Recover from the approved build artifact and deployment evidence only.
3. Do not deploy from an unverified old local folder.
4. Escalate `GAP-001`.

### `SCN-019`: Partner URL or offer is wrong, expired or untagged

1. Pause or remove the affected placement where possible.
2. Verify offer owner, dates, landing page and UTM contract.
3. Correct the partner record and URL.
4. Preserve historical traffic as unknown/incorrectly tagged rather than
   rewriting it.

### `SCN-020`: Creative asset version or approval is unclear

1. Keep the build or ad paused.
2. Identify the source file, owner, version, approval and usage rights.
3. Replace the asset only through the governed build manifest.
4. Record the retired asset and reason.

### `SCN-021`: Agency or vendor access changes

1. Confirm the business owner and required access scope.
2. Inventory active users, service accounts, tokens and recovery owners.
3. Remove or rotate access through the owning platform process.
4. Verify integrations and scheduled jobs still work.
5. Record the change without publishing credentials.

### `SCN-022`: Budget workbook and platform budget disagree

1. Treat the approved budget workbook as plan truth.
2. Compare platform daily/lifetime budgets, spend and remaining forecast.
3. Identify timing, currency, shared-budget and funding-scope differences.
4. Obtain budget-owner approval before changing the platform.

### `SCN-023`: Mailchimp and GreenRope journeys overlap

1. Identify the person/inquiry eligibility and the sending workflow owners.
2. Compare trigger, suppression, frequency and unsubscribe/bounce state.
3. Pause the duplicate journey through the approved owner.
4. Reconcile provider delivery evidence before reactivation.

### `SCN-024`: Organic social or partner traffic cannot be attributed

1. Check landing/referrer and governed link parameters.
2. Report traffic separately from proven lead attribution.
3. Correct future URLs and content keys.
4. Do not assign unattributed inquiries to the channel by assumption.

### `SCN-025`: KPI definitions conflict

1. Compare source, grain, date window, attribution model and deduplication.
2. Route business outcomes to the business-truth source.
3. Route platform delivery to platform IDs and platform definitions.
4. Update the KPI glossary and serving contract after approval.

### `SCN-026`: Campaign experiment audiences or signals contaminate each other

1. Stop declaring a winner.
2. Check audience overlap, exclusions, budget, optimization event, dates and
   attribution settings.
3. Use the platform experiment/A-B framework where available.
4. Restart only with a documented split and success metric.

### `SCN-027`: Supabase and direct business-source outcomes disagree

1. Do not promote a source switch and do not enable a second platform sender.
2. Compare source record IDs, `cefa_event_id`, Form entry ID, outcome grain,
   original timestamps, current-state versus history behavior, corrections,
   merges, deletions, and freshness.
3. Preserve the existing guarded source, lifecycle baseline, accepted-ID log,
   and delivery history during diagnosis.
4. Reconcile one proof-of-concept record and aggregate source totals.
5. Promote only one production outcome source after the versioned contract,
   parity threshold, monitoring, and named rollback owner pass.

Do not re-upload an existing GreenRope or Supabase current-state snapshot as
new conversions.

## Closing A Gap

1. Attach current evidence.
2. Run the stated completion test.
3. Update the narrow owning document.
4. Update this register, the program register and the integration register.
5. Update the machine-readable context manifest.
6. Record the closure date and any residual risk.

Never close a gap because the expected behavior seems likely.
