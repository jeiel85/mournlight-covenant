extends Node2D

@onready var player: CharacterBody2D = $Player
@onready var training_wisp: CharacterBody2D = $TrainingWisp


func _ready() -> void:
	player.add_to_group("player")


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("primary_attack"):
		WorldLedger.record_damage("poison", 12.0, "weapon")
		if player.global_position.distance_to(training_wisp.global_position) < 150.0:
			WorldLedger.record_kill("thorn_court", 1.0)
