extends RefCounted
class_name Combatant

var hp: int = 0
var max_hp: int = 0
var block: int = 0
var statuses: Dictionary = {}

func _init(starting_max_hp: int = 1) -> void:
	max_hp = max(1, starting_max_hp)
	hp = max_hp
	block = 0
	statuses = {}
