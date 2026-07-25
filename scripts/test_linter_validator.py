import os
import pytest
from linter_validator import check_kicad_symbol_file

def test_file_not_found():
    filepath = "non_existent_file.kicad_sym"
    errors = check_kicad_symbol_file(filepath)
    assert errors == [f"File not found: {filepath}"]

def test_valid_symbol(tmp_path):
    sym_file = tmp_path / "valid.kicad_sym"
    sym_file.write_text("""
(symbol "Valid_Symbol"
    (property "MPN" "12345")
    (property "Manufacturer" "Acme")
    (property "Datasheet" "https://example.com/datasheet.pdf")
    (property "Temp_Range" "-40 to 85C")
    (property "DigiKey" "DK-123")
)
""")
    errors = check_kicad_symbol_file(str(sym_file))
    assert errors == []

def test_missing_mandatory_field(tmp_path):
    sym_file = tmp_path / "missing_field.kicad_sym"
    sym_file.write_text("""
(symbol "Missing_MPN"
    (property "Manufacturer" "Acme")
    (property "Datasheet" "https://example.com/datasheet.pdf")
    (property "Temp_Range" "-40 to 85C")
    (property "DigiKey" "DK-123")
)
""")
    errors = check_kicad_symbol_file(str(sym_file))
    assert len(errors) == 1
    assert "missing mandatory field: MPN" in errors[0]

def test_digikey_sku_alias(tmp_path):
    sym_file = tmp_path / "alias.kicad_sym"
    sym_file.write_text("""
(symbol "Alias_Symbol"
    (property "MPN" "12345")
    (property "Manufacturer" "Acme")
    (property "Datasheet" "https://example.com/datasheet.pdf")
    (property "Temp_Range" "-40 to 85C")
    (property "DigiKey_SKU" "DK-123")
)
""")
    errors = check_kicad_symbol_file(str(sym_file))
    assert errors == []

def test_invalid_datasheet_url(tmp_path):
    sym_file = tmp_path / "invalid_url.kicad_sym"
    sym_file.write_text("""
(symbol "Invalid_URL"
    (property "MPN" "12345")
    (property "Manufacturer" "Acme")
    (property "Datasheet" "ftp://example.com/datasheet.pdf")
    (property "Temp_Range" "-40 to 85C")
    (property "DigiKey" "DK-123")
)
""")
    errors = check_kicad_symbol_file(str(sym_file))
    assert len(errors) == 1
    assert "invalid Datasheet URL format" in errors[0]

def test_datasheet_not_pdf(tmp_path):
    sym_file = tmp_path / "not_pdf.kicad_sym"
    sym_file.write_text("""
(symbol "Not_PDF"
    (property "MPN" "12345")
    (property "Manufacturer" "Acme")
    (property "Datasheet" "https://example.com/datasheet.html")
    (property "Temp_Range" "-40 to 85C")
    (property "DigiKey" "DK-123")
)
""")
    errors = check_kicad_symbol_file(str(sym_file))
    assert len(errors) == 1
    assert "must be a PDF URL" in errors[0]

def test_ignore_sub_symbols(tmp_path):
    sym_file = tmp_path / "sub_symbol.kicad_sym"
    sym_file.write_text("""
(symbol "Main_Symbol_0_1"
    (property "MPN" "12345")
)
""")
    errors = check_kicad_symbol_file(str(sym_file))
    assert errors == []

def test_empty_property_value(tmp_path):
    sym_file = tmp_path / "empty_value.kicad_sym"
    sym_file.write_text("""
(symbol "Empty_Value"
    (property "MPN" "")
    (property "Manufacturer" "Acme")
    (property "Datasheet" "https://example.com/datasheet.pdf")
    (property "Temp_Range" "-40 to 85C")
    (property "DigiKey" "DK-123")
)
""")
    errors = check_kicad_symbol_file(str(sym_file))
    assert len(errors) == 1
    assert "missing mandatory field: MPN" in errors[0]

def test_multiple_symbols(tmp_path):
    sym_file = tmp_path / "multiple.kicad_sym"
    sym_file.write_text("""
(symbol "Valid_Symbol"
    (property "MPN" "12345")
    (property "Manufacturer" "Acme")
    (property "Datasheet" "https://example.com/datasheet.pdf")
    (property "Temp_Range" "-40 to 85C")
    (property "DigiKey" "DK-123")
)
(symbol "Invalid_Symbol"
    (property "MPN" "12345")
)
""")
    errors = check_kicad_symbol_file(str(sym_file))
    assert len(errors) == 4
    assert any("missing mandatory field: Manufacturer" in e for e in errors)
    assert any("missing mandatory field: Datasheet" in e for e in errors)
    assert any("missing mandatory field: Temp_Range" in e for e in errors)
    assert any("missing mandatory field: DigiKey" in e for e in errors)
