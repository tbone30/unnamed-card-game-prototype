extends GutTest

func before_each() -> void:
	EquipmentManager.clear_all()
	DeckManager.clear_exhausted()

func _make_card(name: String, cost: int = 1) -> CardDefinition:
	var card := CardDefinition.new()
	card.card_name = name
	card.energy_cost = cost
	return card

func _make_item_with_cards(slot: EquipmentSlot.SlotType, cards: Array[CardDefinition]) -> EquipmentResource:
	var package := CardPackage.new()
	package.cards = cards
	var item := EquipmentResource.new()
	item.slot = slot
	item.item_name = "Item-%s" % String(slot)
	item.card_package = package
	return item

func test_rebuild_deck_collects_cards_from_equipment() -> void:
	var cards: Array[CardDefinition] = [_make_card("A"), _make_card("B")]
	EquipmentManager.equip(_make_item_with_cards(EquipmentSlot.SlotType.WEAPON, cards))
	DeckManager.rebuild_deck()
	assert_eq(DeckManager.draw_pile.size(), 2)

func test_draw_cards_moves_cards_into_hand() -> void:
	EquipmentManager.equip(_make_item_with_cards(EquipmentSlot.SlotType.WEAPON, [_make_card("A")]))
	DeckManager.rebuild_deck()
	var drawn := DeckManager.draw_cards(1)
	assert_eq(drawn.size(), 1)
	assert_eq(DeckManager.hand.size(), 1)

func test_discard_card_moves_card_from_hand_to_discard() -> void:
	var card := _make_card("Discard")
	DeckManager.hand.append(card)
	DeckManager.discard_card(card)
	assert_false(DeckManager.hand.has(card))
	assert_true(DeckManager.discard_pile.has(card))

func test_exhaust_card_removes_card_from_all_runtime_piles() -> void:
	var card := _make_card("Exhaust")
	DeckManager.hand.append(card)
	DeckManager.draw_pile.append(card)
	DeckManager.discard_pile.append(card)
	DeckManager.exhaust_card(card)
	assert_false(DeckManager.hand.has(card))
	assert_false(DeckManager.draw_pile.has(card))
	assert_false(DeckManager.discard_pile.has(card))

func test_set_exhausted_paths_accepts_values() -> void:
	DeckManager.set_exhausted_paths(["res://resources/cards/example.tres"])
	assert_eq(DeckManager.get_exhausted_paths().size(), 1)
