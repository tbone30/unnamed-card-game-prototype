# AGENTS.md — src/ui/

## What this directory owns

All `Control` scenes and their scripts. UI reads from autoloads and emits user-intent signals.
UI never mutates game state directly — it calls autoload methods or emits signals.

## Key scenes

| Scene | Listens to | Calls |
|---|---|---|
| `hand_view` | `DeckManager.deck_rebuilt`, `DeckManager.draw_cards` result | `CombatManager.play_card()` |
| `combat_hud` | `CombatManager.combatant_stat_changed`, `turn_started` | `CombatManager.end_player_turn()` |
| `equipment_panel` | `EquipmentManager.equipment_changed` | `EquipmentManager.equip/unequip()` |
| `map_view` | `RunState.floor_changed` | triggers scene transition |

## Rules

- No game logic in UI scripts — if you're calculating damage in a UI script, move it
- `card_view.gd` only receives a `CardDefinition` and renders it; it does not know about combat
- Drag-and-drop for card play is handled in `hand_view.gd`, not `card_view.gd`