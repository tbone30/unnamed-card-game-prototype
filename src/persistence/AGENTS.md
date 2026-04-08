# AGENTS.md — src/persistence/

## What this directory owns

Saving and loading run state to disk, and meta-progression (cross-run unlocks).

## ⚠ High risk — read carefully before editing

Save format changes break existing save files. Any schema change needs:
1. a version bump in the save file header
2. a migration function `_migrate_vN_to_vN1()` in `save_manager.gd`
3. a note in this file describing what changed and why

## Current save format version: 1

Saved state includes: `RunState` fields, `EquipmentManager` slot contents (item resource paths),
`DeckManager` exhaust list (card resource paths), `MetaProgress` unlock flags.

## Public API

```gdscript
# SaveManager
func save_run() -> void
func load_run() -> bool    # returns false if no save exists
func delete_run() -> void

# MetaProgress (autoload)
func unlock(id: StringName) -> void
func is_unlocked(id: StringName) -> bool
```

## Rules

- Save only resource **paths** (`resource_path`), never inline resource data
- `load_run()` must validate version before applying — call `_migrate()` if needed
- Meta-progress is a separate save file from run state