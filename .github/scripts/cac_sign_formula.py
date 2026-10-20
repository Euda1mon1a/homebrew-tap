"""Kept so older notes still work: same as `wheel_formula.py cac-sign <args>`.

Usage: python3 .github/scripts/cac_sign_formula.py <cac-sign checkout at the release tag> <version> \
           Formula/cac-sign.rb [python minor, default 3.14]
"""
import os, sys

here = os.path.dirname(os.path.abspath(__file__))
os.execv(sys.executable, [sys.executable, os.path.join(here, "wheel_formula.py"), "cac-sign", *sys.argv[1:]])
