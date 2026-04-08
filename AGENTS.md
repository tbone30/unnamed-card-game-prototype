# AGENTS.md — project root

Read this before touching any file in this repo.

## What this project is

A roguelike card battler in Godot 4. The central mechanic: **equipment drives the deck**.
Each `EquipmentResource` carries a `CardPackage` (an array of `CardDefinition`s).
When the player equips or unequips an item, `DeckManager` rebuilds the deck by
collecting all `CardPackage` arrays from currently equipped items. No card list
is hardcoded anywhere outside of `.tres` resource files.

## Architecture in one paragraph

Three autoload singletons own cross-cutting state: `RunState` (HP, floor, gold, equipment slots),
`EquipmentManager` (which items are equipped; emits `equipment_changed`), and `DeckManager`
(current deck composition; listens to `equipment_changed` and rebuilds).
Combat, map, and UI scenes are stateless — they read from autoloads and emit signals back.
All content data (cards, equipment, enemies) lives as `.tres` files in `resources/`.

## Ground rules for agents

1. **Read the subsystem `AGENTS.md` before editing files in that directory.**
2. **Never write game logic in a scene script.** Scene scripts handle input and call autoloads.
3. **Never hardcode card or equipment lists.** All content comes from `.tres` resources.
4. **All cross-system calls go through signals or autoload methods.** No `get_node("../../...")`.
5. **Resource schemas are contracts.** If you change a field name on a Resource class,
   update every `.tres` file that uses it and note the change in the subsystem `AGENTS.md`.
6. **Tests live in `tests/`.** Any new public method on an autoload needs a GUT test.
7. **One responsibility per file.** If a script is doing two things, split it.

## How to approach a task

- **Adding a new card effect type** → `src/data/AGENTS.md`, then `src/combat/AGENTS.md`
- **Adding a new equipment slot** → `src/equipment/AGENTS.md`, then `src/run/AGENTS.md`
- **Changing how the deck is drawn** → `src/deck/AGENTS.md` only
- **Adding a new room type** → `src/run/AGENTS.md`
- **UI-only change** → `src/ui/AGENTS.md` only
- **Save format change** → `src/persistence/AGENTS.md` — high risk, read carefully

## Signal map (cross-system)

```
EquipmentManager
  → equipment_changed(slot: int, item: EquipmentResource)
      listeners: DeckManager, UI/equipment_panel

DeckManager
  → deck_rebuilt(deck: Array[CardDefinition])
      listeners: CombatManager, UI/hand_view

CombatManager
  → combat_ended(player_won: bool)
      listeners: RunState
  → turn_started(is_player_turn: bool)
      listeners: UI/combat_hud

RunState
  → run_ended(won: bool)
      listeners: scenes/main
```

## What does NOT exist yet (as of project init)

- Enemy AI beyond placeholder
- Meta-progression / unlock system
- Any art assets
- Audio
- Map generation beyond a linear sequence

Do not assume these are implemented. Check `src/` before referencing them.