# Test placeholder - requires GUT addon
# extends GutTest

func before_each() -> void:
	RunState.new_run()

func test_new_run_resets_core_stats() -> void:
	RunState.player_hp = 10
	RunState.gold = 99
	RunState.new_run()
	assert_eq(RunState.floor, 1)
	assert_eq(RunState.player_hp, RunState.player_max_hp)
	assert_eq(RunState.gold, 0)

func test_advance_floor_increments_floor() -> void:
	var starting_floor: int = RunState.floor
	RunState.advance_floor()
	assert_eq(RunState.floor, starting_floor + 1)

func test_take_damage_clamps_at_zero() -> void:
	RunState.player_hp = 5
	RunState.take_damage(10)
	assert_eq(RunState.player_hp, 0)

func test_heal_does_not_exceed_max_hp() -> void:
	RunState.player_hp = 1
	RunState.heal(999)
	assert_eq(RunState.player_hp, RunState.player_max_hp)

func test_add_gold_ignores_negative_values() -> void:
	RunState.gold = 2
	RunState.add_gold(-10)
	assert_eq(RunState.gold, 2)
	RunState.add_gold(5)
	assert_eq(RunState.gold, 7)
