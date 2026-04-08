extends GutTest

func before_each() -> void:
	EquipmentManager.clear_all()

func _make_test_item(slot: EquipmentSlot.SlotType) -> EquipmentResource:
	var item := EquipmentResource.new()
	item.item_name = "Test Item"
	item.slot = slot
	item.card_package = CardPackage.new()
	return item

func test_equip_sets_item_in_slot() -> void:
	var item := _make_test_item(EquipmentSlot.SlotType.WEAPON)
	EquipmentManager.equip(item)
	assert_eq(EquipmentManager.get_equipped(EquipmentSlot.SlotType.WEAPON), item)

func test_unequip_clears_slot() -> void:
	var item := _make_test_item(EquipmentSlot.SlotType.ARMOR)
	EquipmentManager.equip(item)
	EquipmentManager.unequip(EquipmentSlot.SlotType.ARMOR)
	assert_null(EquipmentManager.get_equipped(EquipmentSlot.SlotType.ARMOR))

func test_get_equipped_items_returns_non_null_items() -> void:
	EquipmentManager.equip(_make_test_item(EquipmentSlot.SlotType.WEAPON))
	EquipmentManager.equip(_make_test_item(EquipmentSlot.SlotType.RELIC_1))
	assert_eq(EquipmentManager.get_equipped_items().size(), 2)

func test_clear_all_empties_every_slot() -> void:
	for slot in EquipmentSlot.ALL_SLOTS:
		EquipmentManager.equip(_make_test_item(slot))
	EquipmentManager.clear_all()
	assert_eq(EquipmentManager.get_equipped_items().size(), 0)
