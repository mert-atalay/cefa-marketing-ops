# CEFA Marketing Warehouse Dataform QA

This directory is the Git source for the additive Dataform QA project in:

- project: `marketing-api-488017`
- region: `us-central1`
- repository: `cefa-marketing-warehouse-qa`

The first source-controlled baseline reproduces the 12 existing assertion
views and adds three capacity/governance assertions. Compilation is safe and
additive. Do not create a production release or workflow configuration until:

1. the workspace compilation succeeds;
2. all existing assertions reconcile with the current views;
3. the new assertions return zero rows;
4. the Dataform runtime service account and Git connection are approved; and
5. the Cloud Run pipeline remains the production orchestrator during parity.

The Dataform repository is not yet connected to Git. A non-production
workspace may mirror this directory for compilation evidence, but Git remains
the source of truth.
