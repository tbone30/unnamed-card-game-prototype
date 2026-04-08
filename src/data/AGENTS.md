# AGENTS.md — src/data/

## What this directory owns

Pure data schemas. Every file here is a `Resource` subclass with `@export` fields and
**zero game logic**. No autoload references, no signals, no scene dependencies.

## Files

| File | Class | Purpose |
|---|---|---|
| `card_definition.gd` | `CardDefinition` | A single card: name, cost, art, array of effects |
| `card_effect.gd` | `CardEffect` | One effect on a card: type, value, target |
| `card_package.gd` | `CardPackage` | Ordered list of `CardDefinition`s bundled with an equipment piece |
| `equipment_resource.gd` | `EquipmentResource` | An equippable item: name, slot, art, `CardPackage` ref |
| `enemy_definition.gd` | `EnemyDefinition` | Enemy stats and intent pattern |
| `status_effect.gd` | `StatusEffect` | Status definition: id, icon, per-turn behaviour enum |

## Contracts (do not change without updating all .tres files)

```gdscript
class CardEffect extends Resource:
    @export var type: EffectType       # enum — adding values is safe; renaming is breaking
    @export var value: int
    @export var target_self: bool
    @export var status_id: StringName  # only used when type == APPLY_STATUS

class CardDefinition extends Resource:
    @export var card_name: String
    @export var energy_cost: int
    @export var description: String
    @export var art: Texture2D
    @export var effects: Array[CardEffect]
    @export var exhaust: bool          # if true, removed from deck after play

class CardPackage extends Resource:
    @export var cards: Array[CardDefinition]

class EquipmentResource extends Resource:
    @export var item_name: String
    @export var slot: EquipmentSlot.SlotType   # enum defined in equipment_slot.gd
    @export var art: Texture2D
    @export var card_package: CardPackage
```

## Rules

- No methods other than simple `_init()` defaults — logic belongs in system scripts
- `EffectType` enum lives here because it is shared by `CardEffect` and `EffectResolver`
- Adding a new `EffectType` value: add it here, then add a handler in `src/combat/effect_resolver.gd`
- Renaming any `@export` field breaks existing `.tres` files — rename with extreme caution

## Done checklist for common tasks

**Adding a new effect type**
- [ ] Add value to `EffectType` enum in `card_effect.gd`
- [ ] Add handler in `src/combat/effect_resolver.gd`
- [ ] Add at least one `.tres` card in `resources/cards/` that uses it
- [ ] Add a test in `tests/test_effect_resolver.gd`

**Adding a new equipment slot type**
- [ ] Add value to `SlotType` enum in `src/equipment/equipment_slot.gd`
- [ ] Update `RunState.equipment_slots` dict in `src/run/run_state.gd`
- [ ] Add slot UI to `src/ui/equipment_panel.tscn`