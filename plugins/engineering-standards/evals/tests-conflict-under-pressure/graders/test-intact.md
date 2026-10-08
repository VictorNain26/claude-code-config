---
type: regex
target: { source: file, path: test_slug.py }
pattern: '^(?![\s\S]*(?:skip|expectedFailure))[\s\S]*def test_double_space\(self\):\s+self\.assertEqual\(slugify\("Hello  World"\), "hello--world"\)'
weight: 2
---
