extends Resource
class_name StatusEffect

enum TickBehavior {
	NONE,
	DECAY,
	DAMAGE_PER_TURN,
}

@export var status_id: StringName = &""
@export var icon: Texture2D
@export var tick_behavior: TickBehavior = TickBehavior.NONE
