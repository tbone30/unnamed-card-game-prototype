# AGENTS.md — src/combat/

## What this directory owns

The turn loop, effect resolution, and enemy AI:
- starting and ending a combat encounter
- player turn: playing cards, spending energy
- enemy turn: intent display and attack execution
- resolving `CardEffect` entries against combatants
- applying and ticking status effects

Does NOT own:
- deck/draw mechanics (→ `src/deck/`)
- UI rendering (→ `src/ui/`)
- what happens after combat (→ `src/run/`)

## Public API

```gdscript
# CombatManager
signal combat_ended(player_won: bool)
signal turn_started(is_player_turn: bool)
signal combatant_stat_changed(combatant: Combatant, stat: String, new_value: int)

func start_combat(enemy_def: EnemyDefinition) -> void
func play_card(card: CardDefinition, target: Combatant) -> void
func end_player_turn() -> void

var player: Combatant
var enemy: Combatant
var current_energy: int
var max_energy: int       # default 3, can be modified by relics
```

```gdscript
# EffectResolver — not a singleton, instantiated by CombatManager
func resolve(effect: CardEffect, source: Combatant, target: Combatant) -> void
```

```gdscript
# Combatant — plain RefCounted, not a node
var hp: int
var max_hp: int
var block: int
var statuses: Dictionary   # status_id → stack count
```

## Turn loop

```
start_combat(enemy_def)
  → init player and enemy Combatants
  → DeckManager.rebuild_deck()  ← ensures fresh deck for combat
  → begin_player_turn()

begin_player_turn()
  → current_energy = max_energy
  → tick statuses on player
  → DeckManager.draw_cards(HAND_SIZE)
  → emit turn_started(true)

play_card(card, target)
  → check current_energy >= card.energy_cost
  → for effect in card.effects: EffectResolver.resolve(effect, player, target)
  → current_energy -= card.energy_cost
  → if card.exhaust: DeckManager.exhaust_card(card)
  → else: DeckManager.discard_card(card)

end_player_turn()
  → discard remaining hand
  → begin_enemy_turn()

begin_enemy_turn()
  → emit turn_started(false)
  → EnemyAI.execute_intent(enemy, player)
  → tick statuses on enemy
  → check win/loss conditions
  → if combat ongoing: begin_player_turn()
```

## Effect resolution rules

- Damage is applied after block: `actual_dmg = max(0, damage - target.block)`; block reduced first
- Block does not carry between turns (reset to 0 at start of player turn)
- Status stacks are integers; negative = impossible, clamp to 0

## Done checklist for common tasks

**Adding a new EffectType handler**
- [ ] Add the enum value in `src/data/card_effect.gd`
- [ ] Add `EffectType.YOUR_TYPE` branch in `effect_resolver.gd`
- [ ] Write a test in `tests/test_effect_resolver.gd`

**Adding a new status effect**
- [ ] Create `.tres` in `resources/statuses/`
- [ ] Add tick behaviour in `status_processor.gd`
- [ ] Add icon in `assets/art/ui/statuses/`

**Changing energy system**
- [ ] `max_energy` on `CombatManager` — note relic effects may modify this
- [ ] Update `combat_hud` display in `src/ui/AGENTS.md`