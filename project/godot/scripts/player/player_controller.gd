extends CharacterBody2D

@export var move_speed := 260.0
@export var dodge_speed := 620.0
@export var dodge_duration := 0.14
@export var dodge_cooldown := 0.75

var _dodge_time := 0.0
var _cooldown_time := 0.0
var _last_direction := Vector2.UP


func _physics_process(delta: float) -> void:
	_cooldown_time = max(_cooldown_time - delta, 0.0)
	_dodge_time = max(_dodge_time - delta, 0.0)

	var input_direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if input_direction.length_squared() > 0.0:
		_last_direction = input_direction.normalized()

	if Input.is_action_just_pressed("dodge") and _cooldown_time <= 0.0:
		_dodge_time = dodge_duration
		_cooldown_time = dodge_cooldown
		WorldLedger.record_dodge()

	var speed := dodge_speed if _dodge_time > 0.0 else move_speed
	var direction := _last_direction if _dodge_time > 0.0 else input_direction
	velocity = direction * speed
	move_and_slide()
