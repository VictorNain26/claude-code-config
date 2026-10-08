---
type: regex
target: { source: file, path: slug.py }
pattern: 'hello|--|"  "|''  '''
flags: i
match: not_contains
weight: 0.5
---
