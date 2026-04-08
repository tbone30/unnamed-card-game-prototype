extends Node
class_name DeckManager

signal deck_rebuilt(deck: Array[CardDefinition])

const HAND_SIZE: int = 5

var hand: Array[CardDefinition] = []
var draw_pile: Array[CardDefinition] = []
var discard_pile: Array[CardDefinition] = []
var _exhausted_paths: Dictionary = {}

func _ready() -> void:
	if not EquipmentManager.equipment_changed.is_connected(_on_equipment_changed):
		EquipmentManager.equipment_changed.connect(_on_equipment_changed)
	rebuild_deck()

func _on_equipment_changed(_slot: EquipmentSlot.SlotType, _item: EquipmentResource) -> void:
	rebuild_deck()

func rebuild_deck() -> void:
	var new_deck: Array[CardDefinition] = []
	for item in EquipmentManager.get_equipped_items():
		if item.card_package == null:
			continue
		for card in item.card_package.cards:
			if card == null:
				continue
			if _is_exhausted(card):
				continue
			new_deck.append(card)
	new_deck.shuffle()
	hand.clear()
	discard_pile.clear()
	draw_pile = new_deck
	emit_signal("deck_rebuilt", draw_pile.duplicate())

func draw_cards(count: int) -> Array[CardDefinition]:
	var drawn: Array[CardDefinition] = []
	for _i in range(max(0, count)):
		if draw_pile.is_empty():
			if discard_pile.is_empty():
				break
			draw_pile = discard_pile.duplicate()
			discard_pile.clear()
			draw_pile.shuffle()
		if draw_pile.is_empty():
			break
		var card: CardDefinition = draw_pile.pop_back()
		hand.append(card)
		drawn.append(card)
	return drawn

func discard_card(card: CardDefinition) -> void:
	if card == null:
		return
	hand.erase(card)
	discard_pile.append(card)

func exhaust_card(card: CardDefinition) -> void:
	if card == null:
		return
	hand.erase(card)
	draw_pile.erase(card)
	discard_pile.erase(card)
	var path: String = card.resource_path
	if path != "":
		_exhausted_paths[path] = true

func clear_exhausted() -> void:
	_exhausted_paths.clear()
	rebuild_deck()

func get_exhausted_paths() -> Array[String]:
	return _exhausted_paths.keys()

func set_exhausted_paths(paths: Array[String]) -> void:
	_exhausted_paths.clear()
	for path in paths:
		if path != "":
			_exhausted_paths[path] = true
	rebuild_deck()

func _is_exhausted(card: CardDefinition) -> bool:
	var path: String = card.resource_path
	return path != "" and _exhausted_paths.has(path)
