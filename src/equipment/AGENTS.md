# AGENTS.md — src/equipment/

## What this directory owns

Which items are currently equipped and slot management.
Does NOT own card package logic (→ `src/deck/`) or item UI (→ `src/ui/`).

## Public API

```gdscript
# EquipmentManager (autoload)
signal equipment_changed(slot: SlotType, item: EquipmentResource)

func equip(item: EquipmentResource) -> void       # replaces existing item in slot
func unequip(slot: SlotType) -> void
func get_equipped(slot: SlotType) -> EquipmentResource  # returns null if empty
func get_equipped_items() -> Array[EquipmentResource]   # all non-null slots
```

```gdscript
# EquipmentSlot
enum SlotType { WEAPON, ARMOR, RELIC_1, RELIC_2 }
```

## Rules

- `equip()` must emit `equipment_changed` even if replacing an existing item
- Slots not in the enum cannot be equipped to — do not use stringly-typed slot names
- `EquipmentManager` state must be serialized by `src/persistence/save_manager.gd`