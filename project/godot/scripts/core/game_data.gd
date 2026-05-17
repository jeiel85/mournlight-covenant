extends Node

const DATA_ROOT := "res://../../data"

var factions: Array = []
var regions: Array = []
var omens: Dictionary = {}
var weapons: Dictionary = {}


func _ready() -> void:
	reload()


func reload() -> void:
	factions = _load_json_array("%s/factions/factions.json" % DATA_ROOT)
	regions = _load_json_array("%s/regions/regions.json" % DATA_ROOT)
	omens = {
		"omen_poison_dirge": _load_json_object("%s/omens/omen_poison_dirge.json" % DATA_ROOT)
	}
	weapons = {
		"mourning_blade": _load_json_object("%s/weapons/mourning_blade.json" % DATA_ROOT)
	}


func _load_json_array(path: String) -> Array:
	var value := _load_json(path)
	return value if value is Array else []


func _load_json_object(path: String) -> Dictionary:
	var value := _load_json(path)
	return value if value is Dictionary else {}


func _load_json(path: String) -> Variant:
	if not FileAccess.file_exists(path):
		push_warning("Missing data file: %s" % path)
		return null

	var text := FileAccess.get_file_as_string(path)
	var parsed := JSON.parse_string(text)
	if parsed == null:
		push_warning("Invalid JSON data: %s" % path)
	return parsed
