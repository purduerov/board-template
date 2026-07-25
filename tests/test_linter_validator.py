import unittest
import sys
import os
import tempfile

# Adjust sys.path to import linter_validator
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "libs", "purdue-rov-kicad-lib", "scripts")))

from linter_validator import check_kicad_symbol_file

class TestLinterValidator(unittest.TestCase):
    def setUp(self):
        self.temp_dir = tempfile.TemporaryDirectory()

    def tearDown(self):
        self.temp_dir.cleanup()

    def write_test_file(self, content):
        fd, path = tempfile.mkstemp(dir=self.temp_dir.name, suffix='.kicad_sym')
        with os.fdopen(fd, 'w', encoding='utf-8') as f:
            f.write(content)
        return path

    def test_file_not_found(self):
        errors = check_kicad_symbol_file("non_existent_file.kicad_sym")
        self.assertEqual(len(errors), 1)
        self.assertIn("File not found:", errors[0])

    def test_valid_symbol(self):
        content = """(symbol "ValidSymbol"
  (property "MPN" "123")
  (property "Manufacturer" "Texas Instruments")
  (property "Datasheet" "https://example.com/data.pdf")
  (property "Temp_Range" "-40 to 85")
  (property "DigiKey" "123-ND")
)"""
        path = self.write_test_file(content)
        errors = check_kicad_symbol_file(path)
        self.assertEqual(len(errors), 0)

    def test_missing_mandatory_field(self):
        content = """(symbol "InvalidSymbol"
  (property "MPN" "123")
  (property "Manufacturer" "Texas Instruments")
  (property "Datasheet" "https://example.com/data.pdf")
  (property "Temp_Range" "-40 to 85")
)"""
        path = self.write_test_file(content)
        errors = check_kicad_symbol_file(path)
        self.assertEqual(len(errors), 1)
        self.assertIn("missing mandatory field: DigiKey", errors[0])

    def test_digikey_sku_alias(self):
        content = """(symbol "ValidAliasSymbol"
  (property "MPN" "123")
  (property "Manufacturer" "Texas Instruments")
  (property "Datasheet" "https://example.com/data.pdf")
  (property "Temp_Range" "-40 to 85")
  (property "DigiKey_SKU" "123-ND")
)"""
        path = self.write_test_file(content)
        errors = check_kicad_symbol_file(path)
        self.assertEqual(len(errors), 0)

    def test_datasheet_invalid_schema(self):
        content = """(symbol "InvalidSchema"
  (property "MPN" "123")
  (property "Manufacturer" "Texas Instruments")
  (property "Datasheet" "ftp://example.com/data.pdf")
  (property "Temp_Range" "-40 to 85")
  (property "DigiKey" "123-ND")
)"""
        path = self.write_test_file(content)
        errors = check_kicad_symbol_file(path)
        self.assertEqual(len(errors), 1)
        self.assertIn("invalid Datasheet URL format", errors[0])

    def test_datasheet_not_pdf(self):
        content = """(symbol "NotPDF"
  (property "MPN" "123")
  (property "Manufacturer" "Texas Instruments")
  (property "Datasheet" "https://example.com/data.html")
  (property "Temp_Range" "-40 to 85")
  (property "DigiKey" "123-ND")
)"""
        path = self.write_test_file(content)
        errors = check_kicad_symbol_file(path)
        self.assertEqual(len(errors), 1)
        self.assertIn("must be a PDF URL", errors[0])

    def test_sub_symbols_skipped(self):
        content = """(symbol "MainSymbol"
  (property "MPN" "123")
  (property "Manufacturer" "TI")
  (property "Datasheet" "https://test.com/d.pdf")
  (property "Temp_Range" "0")
  (property "DigiKey" "DK")
)
(symbol "MainSymbol_0_1"
  (property "Ignored" "Value")
)
(symbol "MainSymbol_1_1"
)"""
        path = self.write_test_file(content)
        errors = check_kicad_symbol_file(path)
        self.assertEqual(len(errors), 0)

    def test_multiple_symbols(self):
        content = """(symbol "FirstSymbol"
  (property "MPN" "123")
  (property "Manufacturer" "TI")
  (property "Datasheet" "https://test.com/d.pdf")
  (property "Temp_Range" "0")
  (property "DigiKey" "DK")
)
(symbol "SecondSymbol"
  (property "MPN" "456")
  (property "Manufacturer" "ST")
  (property "Datasheet" "https://test.com/d2.pdf")
  (property "Temp_Range" "0")
)"""
        path = self.write_test_file(content)
        errors = check_kicad_symbol_file(path)
        self.assertEqual(len(errors), 1)
        self.assertIn("Symbol 'SecondSymbol' is missing mandatory field: DigiKey", errors[0])

if __name__ == '__main__':
    unittest.main()
