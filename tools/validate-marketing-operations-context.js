"use strict";

const fs = require("fs");
const path = require("path");

const root = path.resolve(__dirname, "..");
const manifestPath = path.join(
  root,
  "data/reference/marketing-operations-context.json"
);
const integrationRegisterPath = path.join(
  root,
  "docs/70-growth-operations/system-and-integration-register.md"
);
const gapRegisterPath = path.join(
  root,
  "docs/70-growth-operations/gap-risk-and-scenario-register.md"
);

const errors = [];

function assert(condition, message) {
  if (!condition) {
    errors.push(message);
  }
}

function assertUnique(values, label) {
  const seen = new Set();

  for (const value of values) {
    if (seen.has(value)) {
      errors.push(`Duplicate ${label}: ${value}`);
    }

    seen.add(value);
  }
}

function assertDocumentContains(document, ids, label) {
  for (const id of ids) {
    assert(document.includes(`\`${id}\``), `${label} missing ${id}`);
  }
}

const manifest = JSON.parse(fs.readFileSync(manifestPath, "utf8"));
const integrationRegister = fs.readFileSync(integrationRegisterPath, "utf8");
const gapRegister = fs.readFileSync(gapRegisterPath, "utf8");

assert(manifest.schema_version === "1.0.0", "Unexpected context schema version");
assert(
  manifest.repository.name === "mert-atalay/cefa-marketing-ops",
  "Unexpected repository name"
);
assert(manifest.repository.visibility === "public", "Visibility must be public");

for (const [name, relativePath] of Object.entries(manifest.canonical_docs)) {
  assert(
    fs.existsSync(path.join(root, relativePath)),
    `Canonical document does not exist: ${name} -> ${relativePath}`
  );
}

const allowedStatuses = new Set(manifest.status_vocabulary);
const systemIds = manifest.systems.map((system) => system.id);
const integrationIds = Object.values(manifest.integration_groups).flat();
const gapIds = manifest.open_gaps.map((gap) => gap.id);
const scenarioIds = manifest.scenario_routes.map((scenario) => scenario.id);

assertUnique(systemIds, "system ID");
assertUnique(integrationIds, "integration ID");
assertUnique(gapIds, "gap ID");
assertUnique(scenarioIds, "scenario ID");

for (const system of manifest.systems) {
  assert(/^SYS-[A-Z0-9-]+$/.test(system.id), `Invalid system ID: ${system.id}`);
  assert(
    allowedStatuses.has(system.status),
    `Invalid system status for ${system.id}: ${system.status}`
  );
}

for (const id of integrationIds) {
  assert(/^INT-[A-Z]+-[0-9]{3}$/.test(id), `Invalid integration ID: ${id}`);
}

for (const gap of manifest.open_gaps) {
  assert(/^GAP-[0-9]{3}$/.test(gap.id), `Invalid gap ID: ${gap.id}`);
  assert(
    allowedStatuses.has(gap.status),
    `Invalid gap status for ${gap.id}: ${gap.status}`
  );
}

for (const scenario of manifest.scenario_routes) {
  assert(/^SCN-[0-9]{3}$/.test(scenario.id), `Invalid scenario ID: ${scenario.id}`);
}

assertDocumentContains(integrationRegister, systemIds, "System register");
assertDocumentContains(integrationRegister, integrationIds, "Integration register");
assertDocumentContains(gapRegister, gapIds, "Gap register");
assertDocumentContains(gapRegister, scenarioIds, "Scenario register");

if (errors.length > 0) {
  console.error("Marketing operations context validation failed:");

  for (const error of errors) {
    console.error(`- ${error}`);
  }

  process.exit(1);
}

console.log(
  `Marketing operations context is valid: ${systemIds.length} systems, ` +
    `${integrationIds.length} integrations, ${gapIds.length} gaps, ` +
    `${scenarioIds.length} scenarios.`
);
