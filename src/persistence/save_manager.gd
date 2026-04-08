extends Node
class_name SaveManager

const SAVE_VERSION: int = 1
const RUN_SAVE_PATH: String = "user://run_save.json"

func save_run() -> void:
	var equipped: Dictionary = {}
	for slot in EquipmentSlot.ALL_SLOTS:
		var item: EquipmentResource = EquipmentManager.get_equipped(slot)
		equipped[String(slot)] = item.resource_path if item != null else ""

	var payload: Dictionary = {
		"version": SAVE_VERSION,
		"run_state": {
			"floor": RunState.floor,
			"player_hp": RunState.player_hp,
			"player_max_hp": RunState.player_max_hp,
			"gold": RunState.gold,
			"run_seed": RunState.run_seed,
		},
		"equipment": equipped,
		"deck": {
			"exhausted_paths": DeckManager.get_exhausted_paths(),
		},
		"meta": {
			"unlock_ids": MetaProgress.get_unlock_ids(),
		},
	}

	var file: FileAccess = FileAccess.open(RUN_SAVE_PATH, FileAccess.WRITE)
	if file == null:
		push_error("Failed to open save file for writing")
		return
	file.store_string(JSON.stringify(payload))

func load_run() -> bool:
	if not FileAccess.file_exists(RUN_SAVE_PATH):
		return false

	var file: FileAccess = FileAccess.open(RUN_SAVE_PATH, FileAccess.READ)
	if file == null:
		return false
	var parsed: Variant = JSON.parse_string(file.get_as_text())
	if typeof(parsed) != TYPE_DICTIONARY:
		return false

	var payload: Dictionary = parsed
	if int(payload.get("version", -1)) != SAVE_VERSION:
		payload = _migrate(payload)
		if payload.is_empty():
			return false

	var run_state: Dictionary = payload.get("run_state", {})
	RunState.floor = int(run_state.get("floor", 1))
	RunState.player_hp = int(run_state.get("player_hp", 80))
	RunState.player_max_hp = int(run_state.get("player_max_hp", 80))
	RunState.gold = int(run_state.get("gold", 0))
	RunState.run_seed = int(run_state.get("run_seed", 0))

	EquipmentManager.clear_all()
	var equipped: Dictionary = payload.get("equipment", {})
	for slot in EquipmentSlot.ALL_SLOTS:
		var item_path: String = String(equipped.get(String(slot), ""))
		if item_path == "":
			continue
		var item: EquipmentResource = load(item_path)
		if item != null:
			EquipmentManager.equip(item)

	var deck_data: Dictionary = payload.get("deck", {})
	DeckManager.set_exhausted_paths(deck_data.get("exhausted_paths", []))

	var meta: Dictionary = payload.get("meta", {})
	MetaProgress.set_unlock_ids(meta.get("unlock_ids", []))
	return true

func delete_run() -> void:
	if FileAccess.file_exists(RUN_SAVE_PATH):
		DirAccess.remove_absolute(RUN_SAVE_PATH)

func _migrate(payload: Dictionary) -> Dictionary:
	var version: int = int(payload.get("version", -1))
	if version == SAVE_VERSION:
		return payload
	return {}
