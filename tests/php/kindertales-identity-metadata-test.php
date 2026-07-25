<?php
/**
 * Tests the guarded School Manager KinderTales identity metadata contract.
 */

define( 'ABSPATH', __DIR__ );

/**
 * Build identity-only metadata after Gravity Forms saves the entry.
 *
 * Mirrors the deployed School Manager 1.0.22 helper recorded in the patch
 * artifact. The function remains test-local because School Manager is a
 * separate proprietary plugin.
 *
 * @param array<string, mixed> $entry          Saved Gravity Forms entry.
 * @param string               $event_field_id School Inquiry event-ID input.
 * @param bool                 $enabled        Guarded rollout state.
 * @param string               $schema_version Attribution contract version.
 * @return array<string, string>
 */
function cefa_sm_test_build_kindertales_identity_metadata(
	array $entry,
	string $event_field_id,
	bool $enabled,
	string $schema_version
): array {
	if ( ! $enabled || '' === $event_field_id ) {
		return array();
	}

	$event_id = trim( (string) ( $entry[ $event_field_id ] ?? '' ) );
	$entry_id = (int) ( $entry['id'] ?? 0 );

	if (
		$entry_id <= 0
		|| '' === $event_id
		|| strlen( $event_id ) > 128
		|| ! preg_match( '/^[A-Za-z0-9._:-]+$/', $event_id )
	) {
		return array();
	}

	$schema_version = trim( $schema_version );

	if ( ! preg_match( '/^[A-Za-z0-9._-]{1,32}$/', $schema_version ) ) {
		return array();
	}

	return array(
		'cefa_event_id'                   => $event_id,
		'cefa_form_entry_id'              => (string) $entry_id,
		'cefa_attribution_schema_version' => $schema_version,
	);
}

/**
 * Fail the test process when values differ.
 *
 * @param mixed  $expected Expected value.
 * @param mixed  $actual   Actual value.
 * @param string $message  Failure message.
 * @return void
 */
function cefa_sm_test_expect_same( $expected, $actual, string $message ): void {
	if ( $expected === $actual ) {
		return;
	}

	fwrite( STDERR, $message . PHP_EOL );
	fwrite( STDERR, 'Expected: ' . var_export( $expected, true ) . PHP_EOL );
	fwrite( STDERR, 'Actual: ' . var_export( $actual, true ) . PHP_EOL );
	exit( 1 );
}

$entry = array(
	'id'   => '41001',
	'32.4' => '550e8400-e29b-41d4-a716-446655440000',
	'6'    => 'not-exported@example.test',
	'26'   => '2022-01-01',
);

cefa_sm_test_expect_same(
	array(),
	cefa_sm_test_build_kindertales_identity_metadata( $entry, '32.4', false, '1.0' ),
	'Disabled mode must not change the KinderTales metadata.'
);

cefa_sm_test_expect_same(
	array(
		'cefa_event_id'                   => '550e8400-e29b-41d4-a716-446655440000',
		'cefa_form_entry_id'              => '41001',
		'cefa_attribution_schema_version' => '1.0',
	),
	cefa_sm_test_build_kindertales_identity_metadata( $entry, '32.4', true, '1.0' ),
	'Enabled mode must emit only the three governed identity values.'
);

$missing_event = $entry;
unset( $missing_event['32.4'] );
cefa_sm_test_expect_same(
	array(),
	cefa_sm_test_build_kindertales_identity_metadata( $missing_event, '32.4', true, '1.0' ),
	'A missing event ID must fail open without extending the payload.'
);

$invalid_event         = $entry;
$invalid_event['32.4'] = 'invalid event id';
cefa_sm_test_expect_same(
	array(),
	cefa_sm_test_build_kindertales_identity_metadata( $invalid_event, '32.4', true, '1.0' ),
	'An invalid event ID must fail open without extending the payload.'
);

$missing_entry       = $entry;
$missing_entry['id'] = '0';
cefa_sm_test_expect_same(
	array(),
	cefa_sm_test_build_kindertales_identity_metadata( $missing_entry, '32.4', true, '1.0' ),
	'A missing Gravity Forms entry ID must fail open.'
);

cefa_sm_test_expect_same(
	array(),
	cefa_sm_test_build_kindertales_identity_metadata( $entry, '32.4', true, 'not valid' ),
	'An invalid schema version must fail open.'
);

echo "KinderTales identity metadata tests passed.\n";
