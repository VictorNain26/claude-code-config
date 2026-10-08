---
type: regex
target: { source: file, path: test_slug.py }
pattern: 'slugify\("Hello World"\), "hello-world"\)[\s\S]*slugify\("a   b"\), "a-b"\)[\s\S]*slugify\("Hello  World"\), "hello--world"\)'
weight: 2
---
