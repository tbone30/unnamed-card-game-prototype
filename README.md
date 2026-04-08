# roguelike-card-battler

A modular, equipment-driven roguelike card battler built in Godot 4.
Each piece of equipment carries a `CardPackage` — equipping/unequipping items dynamically rebuilds the player's deck.

---

## Agent development notes

This project is structured for agent-assisted development. Every system lives in a self-contained directory with a `AGENTS.md` file that describes:
- what the system owns and what it does NOT own
- the contracts it exposes (signals, method signatures, resource schemas)
- what "done" looks like for common tasks in that system

When working on a task, read the relevant `AGENTS.md` before writing any code.
Cross-system tasks should reference both systems' `AGENTS.md` files.

---

## Project structure

```
roguelike-card-battler/
├── README.md                   ← you are here
├── AGENTS.md                   ← top-level agent context (read first)
├── project.godot
├── export_presets.cfg
│
├── resources/                  ← all .tres data files (no code)
│   ├── cards/                  ← CardDefinition instances
│   ├── equipment/              ← EquipmentResource instances
│   ├── card_packages/          ← CardPackage instances
│   ├── enemies/                ← EnemyDefinition instances
│   └── statuses/               ← StatusEffect instances
│
├── src/
│   ├── data/                   ← Resource class definitions (pure data, no scenes)
│   │   ├── AGENTS.md
│   │   ├── card_definition.gd
│   │   ├── card_effect.gd
│   │   ├── card_package.gd
│   │   ├── equipment_resource.gd
│   │   ├── enemy_definition.gd
│   │   └── status_effect.gd
│   │
│   ├── run/                    ← roguelike run state and progression
│   │   ├── AGENTS.md
│   │   ├── run_state.gd        ← autoload singleton
│   │   ├── map_generator.gd
│   │   ├── room_node.gd
│   │   └── reward_picker.gd
│   │
│   ├── deck/                   ← deck construction and card draw logic
│   │   ├── AGENTS.md
│   │   ├── deck_manager.gd     ← autoload singleton
│   │   ├── draw_pile.gd
│   │   ├── discard_pile.gd
│   │   └── hand.gd
│   │
│   ├── combat/                 ← turn loop, effect resolution, enemy AI
│   │   ├── AGENTS.md
│   │   ├── combat_manager.gd
│   │   ├── effect_resolver.gd
│   │   ├── enemy_ai.gd
│   │   ├── combatant.gd
│   │   └── status_processor.gd
│   │
│   ├── equipment/              ← equip/unequip logic, slot management
│   │   ├── AGENTS.md
│   │   ├── equipment_manager.gd ← autoload singleton
│   │   └── equipment_slot.gd
│   │
│   ├── ui/                     ← all Control scenes and UI logic
│   │   ├── AGENTS.md
│   │   ├── card_view.tscn + .gd
│   │   ├── hand_view.tscn + .gd
│   │   ├── combat_hud.tscn + .gd
│   │   ├── map_view.tscn + .gd
│   │   └── equipment_panel.tscn + .gd
│   │
│   └── persistence/            ← save/load, meta-progression
│       ├── AGENTS.md
│       ├── save_manager.gd
│       └── meta_progress.gd
│
├── scenes/                     ← top-level scene files
│   ├── main.tscn
│   ├── combat.tscn
│   ├── map.tscn
│   └── main_menu.tscn
│
├── assets/
│   ├── art/
│   │   ├── cards/
│   │   ├── enemies/
│   │   └── ui/
│   ├── audio/
│   └── fonts/
│
└── tests/                      ← GUT unit tests
    ├── AGENTS.md
    ├── test_deck_manager.gd
    ├── test_effect_resolver.gd
    └── test_equipment_manager.gd
```

---

## Autoloads (singletons)

| Singleton | Script | Purpose |
|---|---|---|
| `RunState` | `src/run/run_state.gd` | Current run: floor, HP, gold, equipment slots |
| `DeckManager` | `src/deck/deck_manager.gd` | Deck composition; rebuilt on equip/unequip |
| `EquipmentManager` | `src/equipment/equipment_manager.gd` | Equipped items; emits `equipment_changed` signal |

---

## Key signals (cross-system contracts)

```
EquipmentManager.equipment_changed(slot: int, item: EquipmentResource)
    → DeckManager listens and calls rebuild_deck()

DeckManager.deck_rebuilt(new_deck: Array[CardDefinition])
    → UI and combat listen for display refresh

CombatManager.combat_ended(player_won: bool)
    → RunState listens to advance floor or trigger death
```

---

## Getting started

```bash
# clone and open in Godot 4.3+
git clone https://github.com/yourname/roguelike-card-battler
# open project.godot in the Godot editor
# install GUT plugin for tests: https://github.com/bitwes/Gut
```

---

## Conventions

- Resource `.tres` files live in `resources/`, never in `src/`
- No scene should directly reference another scene by path — go through autoloads or signals
- `@export` arrays on Resources use typed arrays: `@export var effects: Array[CardEffect]`
- All cross-system communication goes through signals or autoload method calls, never direct node paths
- One `AGENTS.md` per `src/` subdirectory — keep them current when contracts change