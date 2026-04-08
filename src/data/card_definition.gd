extends Resource
class_name CardDefinition

@export var card_name: String = "Unnamed Card"
@export var energy_cost: int = 1
@export_multiline var description: String = ""
@export var art: Texture2D
@export var effects: Array[CardEffect] = []
@export var exhaust: bool = false
