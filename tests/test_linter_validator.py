import unittest
import os
import sys

# Add the directory containing the script to the python path
sys.path.insert(0, os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), "libs", "purdue-rov-kicad-lib", "scripts"))

from linter_validator import check_kicad_symbol_file

class TestLinterValidator(unittest.TestCase):
    def test_file_not_found(self):
        non_existent_file = "non_existent_file.kicad_sym"
        expected_error = [f"File not found: {non_existent_file}"]
        result = check_kicad_symbol_file(non_existent_file)
        self.assertEqual(result, expected_error)

if __name__ == '__main__':
    unittest.main()
