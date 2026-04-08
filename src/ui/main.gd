extends Control

@onready var floor_label: Label = %FloorLabel

func _ready() -> void:
	RunState.new_run()
	var starter_sword: EquipmentResource = load("res://resources/equipment/starter_sword.tres")
	if starter_sword != null:
		EquipmentManager.equip(starter_sword)
	_update_floor(RunState.floor)
	if not RunState.floor_changed.is_connected(_update_floor):
		RunState.floor_changed.connect(_update_floor)

func _on_start_combat_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/combat.tscn")

func _on_map_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/map.tscn")

func _on_save_pressed() -> void:
	SaveManager.save_run()

func _on_load_pressed() -> void:
	SaveManager.load_run()
	_update_floor(RunState.floor)

func _update_floor(new_floor: int) -> void:
	floor_label.text = "Floor: %d" % new_floor
