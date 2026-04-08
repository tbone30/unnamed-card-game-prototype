extends Control

var _combat_manager: CombatManager

func bind_combat_manager(combat_manager: CombatManager) -> void:
	if combat_manager == null:
		return
	_combat_manager = combat_manager
	if not combat_manager.turn_started.is_connected(_on_turn_started):
		combat_manager.turn_started.connect(_on_turn_started)

func _on_end_turn_pressed() -> void:
	if _combat_manager != null:
		_combat_manager.end_player_turn()

func _on_turn_started(_is_player_turn: bool) -> void:
	pass
