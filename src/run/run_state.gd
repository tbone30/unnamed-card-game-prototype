extends Node

signal run_ended(won: bool)
signal floor_changed(new_floor: int)

var floor: int = 1
var player_hp: int = 80
var player_max_hp: int = 80
var gold: int = 0
var run_seed: int = 0

func new_run() -> void:
	floor = 1
	player_max_hp = 80
	player_hp = player_max_hp
	gold = 0
	run_seed = int(Time.get_unix_time_from_system())
	var equipment_manager: Node = get_node_or_null("/root/EquipmentManager")
	if equipment_manager != null:
		EquipmentManager.clear_all()
	var deck_manager: Node = get_node_or_null("/root/DeckManager")
	if deck_manager != null:
		DeckManager.clear_exhausted()
	emit_signal("floor_changed", floor)

func advance_floor() -> void:
	floor += 1
	emit_signal("floor_changed", floor)

func take_damage(amount: int) -> void:
	player_hp = max(0, player_hp - max(amount, 0))
	if player_hp <= 0:
		emit_signal("run_ended", false)

func heal(amount: int) -> void:
	player_hp = min(player_max_hp, player_hp + max(amount, 0))

func add_gold(amount: int) -> void:
	gold += max(amount, 0)
