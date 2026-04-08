extends Control

func refresh_from_deck(deck: Array) -> void:
	visible = not deck.is_empty()
