extends RefCounted
class_name EffectResolver

func resolve(effect: CardEffect, source: Combatant, target: Combatant) -> void:
	if effect == null or source == null or target == null:
		return

	match effect.type:
		CardEffect.EffectType.DAMAGE:
			var incoming: int = max(0, effect.value)
			var absorbed: int = min(target.block, incoming)
			target.block -= absorbed
			target.hp = max(0, target.hp - (incoming - absorbed))
		CardEffect.EffectType.GAIN_BLOCK:
			target.block += max(0, effect.value)
		CardEffect.EffectType.DRAW:
			DeckManager.draw_cards(max(0, effect.value))
		CardEffect.EffectType.APPLY_STATUS:
			if effect.status_id != &"":
				var current: int = int(target.statuses.get(effect.status_id, 0))
				target.statuses[effect.status_id] = max(0, current + max(0, effect.value))
