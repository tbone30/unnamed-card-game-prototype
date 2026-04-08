extends Node

signal equipment_changed(slot: EquipmentSlot.SlotType, item: EquipmentResource)

var _equipped: Dictionary = {}

func _ready() -> void:
	for slot in EquipmentSlot.ALL_SLOTS:
		if not _equipped.has(slot):
			_equipped[slot] = null

func equip(item: EquipmentResource) -> void:
	if item == null:
		return
	_equipped[item.slot] = item
	emit_signal("equipment_changed", item.slot, item)

func unequip(slot: EquipmentSlot.SlotType) -> void:
	_equipped[slot] = null
	emit_signal("equipment_changed", slot, null)

func clear_all() -> void:
	for slot in EquipmentSlot.ALL_SLOTS:
		unequip(slot)

func get_equipped(slot: EquipmentSlot.SlotType) -> EquipmentResource:
	return _equipped.get(slot, null)

func get_equipped_items() -> Array[EquipmentResource]:
	var items: Array[EquipmentResource] = []
	for slot in EquipmentSlot.ALL_SLOTS:
		var item: EquipmentResource = _equipped.get(slot, null)
		if item != null:
			items.append(item)
	return items
