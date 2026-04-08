# AGENTS.md — src/run/

## What this directory owns

Roguelike run lifecycle: floors, room sequencing, rewards, and top-level player stats (HP, gold).

## Public API

```gdscript
# RunState (autoload)
signal run_ended(won: bool)
signal floor_changed(new_floor: int)

func new_run() -> void          # resets all run state
func advance_floor() -> void
func take_damage(amount: int) -> void
func heal(amount: int) -> void
func add_gold(amount: int) -> void

var floor: int
var player_hp: int
var player_max_hp: int
var gold: int
```

## Rules

- `RunState` does NOT know about deck or equipment internals — it only tracks HP/gold/floor
- `new_run()` must notify `EquipmentManager` to clear slots and `DeckManager` to clear exhaust list
- Map generation is deterministic given a seed stored in `RunState.run_seed`