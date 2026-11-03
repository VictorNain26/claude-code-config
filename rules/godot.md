---
paths:
  - "**/*.gd"
  - "**/*.tscn"
  - "**/*.tres"
  - "**/project.godot"
---

# Godot

- Godot 4 uniquement : la version du projet est dans son `mise.toml`. Pas d'API Godot 3 (`yield`, `KinematicBody2D`, `rand_range`…) ; en cas de doute, consulter la doc via Context7 (`/godotengine/godot-docs`, branche de la version épinglée).
- Les scènes et ressources (`.tscn`, `.tres`, `.uid`) se modifient par les outils godot-ai (éditeur ouvert) ou par un script `godot --headless` ; Edit et Write y sont refusés par permission.
- Un comportement visible se vérifie dans le jeu lancé : `project_run`, puis `game_manage` (`suspend`, entrées, `next_frame`) et `editor_screenshot` en mode `game` sur plusieurs images, et `logs_read` pour les erreurs.
