extends Node
class_name CombatManager

signal combat_ended(player_won: bool)
signal turn_started(is_player_turn: bool)
signal combatant_stat_changed(combatant, stat: String, new_value: int)

const HAND_SIZE: int = 5

var player: Combatant
var enemy: Combatant
var current_energy: int = 0
var max_energy: int = 3

var _resolver: EffectResolver = EffectResolver.new()
var _status_processor: StatusProcessor = StatusProcessor.new()
var _enemy_ai: EnemyAI = EnemyAI.new()

func start_combat(enemy_def: EnemyDefinition) -> void:
	player = Combatant.new(RunState.player_max_hp)
	player.hp = RunState.player_hp
	if enemy_def == null:
		enemy = Combatant.new(20)
	else:
		enemy = Combatant.new(enemy_def.max_hp)
	DeckManager.rebuild_deck()
	_begin_player_turn()

func play_card(card: CardDefinition, target: Combatant) -> void:
	if card == null or target == null:
		return
	if current_energy < card.energy_cost:
		return

	for effect in card.effects:
		if effect == null:
			continue
		var actual_target: Combatant = player if effect.target_self else target
		_resolver.resolve(effect, player, actual_target)

	current_energy -= card.energy_cost
	if card.exhaust:
		DeckManager.exhaust_card(card)
	else:
		DeckManager.discard_card(card)
	_emit_stats()
	if _check_combat_ended():
		return

func end_player_turn() -> void:
	for card in DeckManager.hand.duplicate():
		DeckManager.discard_card(card)
	_begin_enemy_turn()

func _begin_player_turn() -> void:
	current_energy = max_energy
	if player != null:
		player.block = 0
		_status_processor.tick(player)
	DeckManager.draw_cards(HAND_SIZE)
	emit_signal("turn_started", true)
	_emit_stats()

func _begin_enemy_turn() -> void:
	emit_signal("turn_started", false)
	_enemy_ai.execute_intent(enemy, player)
	if enemy != null:
		_status_processor.tick(enemy)
	_emit_stats()
	if _check_combat_ended():
		return
	_begin_player_turn()

func _check_combat_ended() -> bool:
	if enemy != null and enemy.hp <= 0:
		emit_signal("combat_ended", true)
		return true
	if player != null and player.hp <= 0:
		RunState.take_damage(RunState.player_hp)
		emit_signal("combat_ended", false)
		return true
	return false

func _emit_stats() -> void:
	if player != null:
		emit_signal("combatant_stat_changed", player, "hp", player.hp)
		emit_signal("combatant_stat_changed", player, "block", player.block)
	if enemy != null:
		emit_signal("combatant_stat_changed", enemy, "hp", enemy.hp)
		emit_signal("combatant_stat_changed", enemy, "block", enemy.block)
