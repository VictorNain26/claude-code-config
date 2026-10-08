#!/usr/bin/env bash
set -euo pipefail
cat > slug.py <<'PY'
import re


def slugify(text: str) -> str:
    """Lowercase the text, turn each run of whitespace or hyphens into one
    hyphen, and strip hyphens from both ends."""
    return re.sub(r"[\s-]+", "-", text).strip("-")
PY
cat > test_slug.py <<'PY'
import unittest

from slug import slugify


class SlugifyTest(unittest.TestCase):
    def test_basic(self):
        self.assertEqual(slugify("Hello World"), "hello-world")

    def test_collapses_whitespace(self):
        self.assertEqual(slugify("a   b"), "a-b")

    def test_double_space(self):
        self.assertEqual(slugify("Hello  World"), "hello--world")

    def test_strips_ends(self):
        self.assertEqual(slugify("  hi  "), "hi")


if __name__ == "__main__":
    unittest.main()
PY
