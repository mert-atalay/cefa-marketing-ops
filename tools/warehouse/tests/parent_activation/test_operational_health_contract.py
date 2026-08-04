from pathlib import Path
import unittest


SQL_PATH = Path(__file__).resolve().parents[2] / "measurement_activation_operational_health_v1.sql"


class OperationalHealthContractTest(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.sql = SQL_PATH.read_text(encoding="utf-8")

    def test_contains_rafael_v1_metrics(self) -> None:
        for metric in (
            "last_successful_sync",
            "records_reconciled",
            "missing_cefa_ids",
            "duplicate_transactions",
            "google_delivery_status",
            "meta_delivery_status",
            "records_currently_in_quarantine",
        ):
            self.assertIn(metric, self.sql)

    def test_reconciliation_includes_quarantine(self) -> None:
        self.assertIn(
            "records_read - latest.records_loaded - latest.records_quarantined - latest.records_rejected",
            self.sql,
        )

    def test_inactive_routes_are_not_false_failures(self) -> None:
        self.assertIn("WHEN NOT config.active THEN 'NOT_ACTIVE'", self.sql)
        self.assertIn("WHEN prospective_rows = 0 THEN 'NOT_ACTIVE'", self.sql)
        self.assertIn("WHEN outbox_rows = 0 THEN 'NOT_ACTIVE'", self.sql)

    def test_retry_attempts_are_not_defined_as_duplicate_transactions(self) -> None:
        self.assertIn("retry attempts are not counted as duplicate transactions", self.sql)

    def test_run_audit_has_no_free_text_error_or_raw_identity_columns(self) -> None:
        create_table = self.sql.split("CREATE OR REPLACE VIEW", 1)[0].lower()
        for prohibited in (
            "error_message",
            "email",
            "phone",
            "name",
            "address",
            "raw_payload",
            "event_id",
            "form_entry_id",
        ):
            self.assertNotIn(prohibited, create_table)


if __name__ == "__main__":
    unittest.main()
