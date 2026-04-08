extends RefCounted
class_name EnemyAI

func execute_intent(enemy: Combatant, player: Combatant) -> void:
	if enemy == null or player == null:
		return
	var incoming: int = 5
	var absorbed: int = min(player.block, incoming)
	player.block -= absorbed
	player.hp = max(0, player.hp - (incoming - absorbed))
