extends CharacterBody2D

@export var drift_speed := 80.0
@export var faction_id := "thorn_court"

var _target: Node2D


func _ready() -> void:
	_target = get_tree().get_first_node_in_group("player")


func _physics_process(_delta: float) -> void:
	if _target == null:
		_target = get_parent().get_node_or_null("Player")
	if _target == null:
		return

	var direction := global_position.direction_to(_target.global_position)
	velocity = direction * drift_speed
	move_and_slide()
