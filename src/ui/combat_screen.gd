extends Control

var _combat_manager: CombatManager

@onready var player_hp_label: Label = %PlayerHpLabel
@onready var enemy_hp_label: Label = %EnemyHpLabel
@onready var turn_label: Label = %TurnLabel

func _ready() -> void:
	_combat_manager = CombatManager.new()
	add_child(_combat_manager)
	_combat_manager.combatant_stat_changed.connect(_on_stat_changed)
	_combat_manager.turn_started.connect(_on_turn_started)
	_combat_manager.combat_ended.connect(_on_combat_ended)
	_combat_manager.start_combat(null)

func _on_end_turn_pressed() -> void:
	_combat_manager.end_player_turn()

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")

func _on_stat_changed(combatant: Combatant, stat: String, new_value: int) -> void:
	if combatant == _combat_manager.player and stat == "hp":
		player_hp_label.text = "Player HP: %d" % new_value
	if combatant == _combat_manager.enemy and stat == "hp":
		enemy_hp_label.text = "Enemy HP: %d" % new_value

func _on_turn_started(is_player_turn: bool) -> void:
	turn_label.text = "Turn: Player" if is_player_turn else "Turn: Enemy"

func _on_combat_ended(player_won: bool) -> void:
	turn_label.text = "Combat Ended: %s" % ("Victory" if player_won else "Defeat")
