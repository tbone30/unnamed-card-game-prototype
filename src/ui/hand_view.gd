extends Control

func refresh_from_deck(deck: Array[CardDefinition]) -> void:
	visible = not deck.is_empty()
