extends Control

@onready var card_name_label: Label = %CardNameLabel

func set_card(card) -> void:
	if card == null:
		card_name_label.text = ""
		return
	card_name_label.text = card.card_name
