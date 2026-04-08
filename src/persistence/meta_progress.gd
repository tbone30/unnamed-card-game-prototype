extends Node
class_name MetaProgress

var _unlock_flags: Dictionary = {}

func unlock(id: StringName) -> void:
	if id == &"":
		return
	_unlock_flags[id] = true

func is_unlocked(id: StringName) -> bool:
	return _unlock_flags.get(id, false)

func get_unlock_ids() -> Array[String]:
	var ids: Array[String] = []
	for key in _unlock_flags.keys():
		ids.append(String(key))
	return ids

func set_unlock_ids(ids: Array[String]) -> void:
	_unlock_flags.clear()
	for id in ids:
		if id != "":
			_unlock_flags[StringName(id)] = true
