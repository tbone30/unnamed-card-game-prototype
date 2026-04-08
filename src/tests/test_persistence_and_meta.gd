extends GutTest

func before_each() -> void:
	SaveManager.delete_run()
	MetaProgress.set_unlock_ids([])
	RunState.new_run()

func test_unlock_and_lookup_meta_progress() -> void:
	var id := StringName("starter_unlock")
	MetaProgress.unlock(id)
	assert_true(MetaProgress.is_unlocked(id))

func test_set_unlock_ids_round_trip() -> void:
	MetaProgress.set_unlock_ids(["a", "b"])
	assert_eq(MetaProgress.get_unlock_ids().size(), 2)

func test_save_load_delete_run_smoke() -> void:
	RunState.gold = 12
	MetaProgress.unlock(StringName("smoke_unlock"))
	SaveManager.save_run()

	RunState.gold = 0
	MetaProgress.set_unlock_ids([])
	assert_true(SaveManager.load_run())
	assert_eq(RunState.gold, 12)
	assert_true(MetaProgress.is_unlocked(StringName("smoke_unlock")))

	SaveManager.delete_run()
	assert_false(SaveManager.load_run())
