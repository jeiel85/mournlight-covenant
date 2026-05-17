extends Node

@export var sandbox_scene: PackedScene
@export var ledger_result_scene: PackedScene

var _ledger_view: CanvasLayer


func _ready() -> void:
	var sandbox := sandbox_scene.instantiate()
	add_child(sandbox)

	_ledger_view = ledger_result_scene.instantiate()
	add_child(_ledger_view)

	WorldLedger.reset_run()
	_ledger_view.show_result(WorldLedger.preview_result())
