extends Resource
class_name CardEffect

enum EffectType {
	DAMAGE,
	GAIN_BLOCK,
	DRAW,
	APPLY_STATUS,
}

@export var type: EffectType = EffectType.DAMAGE
@export var value: int = 0
@export var target_self: bool = false
@export var status_id: StringName = &""
