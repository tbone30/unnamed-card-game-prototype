# AGENTS.md — tests/

## What this directory owns

GUT unit tests for all autoload public methods and `EffectResolver`.

## Conventions

- One test file per system: `test_deck_manager.gd`, `test_effect_resolver.gd`, `test_equipment_manager.gd`
- Test file naming: `test_<system>.gd`
- Each public method on an autoload needs at least one happy-path test
- Use `gut.p("description")` before each test group

## Running tests

Open GUT panel in Godot editor → Run All, or run headless:
```bash
godot --headless -s addons/gut/gut_cmdln.gd
```