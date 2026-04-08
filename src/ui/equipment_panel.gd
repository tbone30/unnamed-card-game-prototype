extends Control

func equip_item(item: EquipmentResource) -> void:
	EquipmentManager.equip(item)

func unequip_slot(slot: EquipmentSlot.SlotType) -> void:
	EquipmentManager.unequip(slot)
