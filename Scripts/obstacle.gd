class_name Obstacle

extends Area2D

enum Behavior { STOP, SLOW }

@export var affect_combo = false
@export var fuel_change: int
@export var disappear_on_collide: bool
@export var behavior: Behavior
@export var slow_percentage: float
@export var random_rotation: bool = false
@export var rotate_auto:bool = false
@export var rotate_speed: float = 5.0

var rotate_clockwise = true

var is_positive: bool:
	get:
		return fuel_change > 0
		
func _ready() -> void:
	if random_rotation:
		global_rotation_degrees = randf_range(0, 360.0)
	if rotate_auto && randi_range(0,1) == 1:
		rotate_clockwise = false

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		GameManager.current_fuel += fuel_change
		if !is_positive:
			body.on_obstacle_collide(self)
			if affect_combo:
				GameManager.current_combo = 1
		else:
			if affect_combo:
				GameManager.current_combo += 1
			body.launch_collect_event()
		if disappear_on_collide:
			queue_free()
			
func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		body.on_obstacle_end_collide(self)
	pass

func _process(delta: float) -> void:
	if rotate_auto:
		var rotate_sign = 1.0
		if rotate_clockwise:
			rotate_sign = -1.0
		rotation_degrees += rotate_speed * delta * rotate_sign
