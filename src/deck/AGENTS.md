# AGENTS.md — src/deck/

## What this directory owns

Everything about **deck composition and card draw mechanics**:
- rebuilding the deck when equipment changes
- the draw pile, discard pile, and hand as runtime state
- shuffle logic

This directory does NOT own:
- what cards do (→ `src/combat/`)
- which items are equipped (→ `src/equipment/`)
- UI rendering of the hand (→ `src/ui/`)

## Autoload

`DeckManager` is registered as an autoload singleton.

## Public API

```gdscript
# DeckManager
signal deck_rebuilt(deck: Array[CardDefinition])

func rebuild_deck() -> void
    # Called automatically on EquipmentManager.equipment_changed
    # Collects CardPackage from every equipped EquipmentResource
    # Populates draw_pile and emits deck_rebuilt

func draw_cards(count: int) -> Array[CardDefinition]
    # Draw from draw_pile; shuffle discard into draw if empty

func discard_card(card: CardDefinition) -> void
func exhaust_card(card: CardDefinition) -> void   # removed for remainder of run

var hand: Array[CardDefinition]          # current cards in hand (read-only externally)
var draw_pile: Array[CardDefinition]     # read-only externally
var discard_pile: Array[CardDefinition]  # read-only externally
```

## Internal flow

```
EquipmentManager.equipment_changed
  → DeckManager.rebuild_deck()
      → iterate EquipmentManager.get_equipped_items()
      → for each: append item.card_package.cards to new_deck[]
      → shuffle new_deck
      → assign to draw_pile, clear hand and discard
      → emit deck_rebuilt(draw_pile)
```

## Rules

- `DeckManager` never reads from `RunState` directly — only from `EquipmentManager`
- Do not store `CardDefinition` references across combat boundaries; rebuild on each new combat
- `exhaust_card` removes permanently for the run; this list resets on `RunState.new_run()`

## Done checklist for common tasks

**Changing draw count per turn**
- [ ] Update default `HAND_SIZE` constant in `deck_manager.gd`
- [ ] Check if any card effect modifies draw count via `DeckManager.draw_cards(n)` calls

**Adding a "banish" mechanic (remove card from deck permanently)**
- [ ] Add `banish_card(card)` method to `DeckManager`
- [ ] Store banished cards in a separate array, exclude during `rebuild_deck()`
- [ ] Wire up UI in `src/ui/AGENTS.md`