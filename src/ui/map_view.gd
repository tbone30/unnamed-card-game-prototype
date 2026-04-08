extends Control

@onready var floor_label: Label = %FloorLabel

func _ready() -> void:
	floor_label.text = "Map Placeholder - Floor %d" % RunState.floor

func _on_advance_floor_pressed() -> void:
	RunState.advance_floor()
	floor_label.text = "Map Placeholder - Floor %d" % RunState.floor

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")
