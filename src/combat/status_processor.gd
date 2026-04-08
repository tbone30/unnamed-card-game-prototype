extends RefCounted
class_name StatusProcessor

func tick(combatant: Combatant) -> void:
	if combatant == null:
		return
	var to_remove: Array[StringName] = []
	for status_id in combatant.statuses.keys():
		var stacks: int = int(combatant.statuses[status_id])
		if stacks <= 0:
			to_remove.append(status_id)
	for status_id in to_remove:
		combatant.statuses.erase(status_id)
