class_name Obstacle

extends Area2D

enum Behavior { STOP, SLOW }

@export var fuel_change: int
@export var disappear_on_collide: bool
@export var behavior: Behavior
@export var slow_percentage: float
var is_positive: bool:
	get:
		return fuel_change > 0

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		GameManager.current_fuel += fuel_change
		if !is_positive:
			body.on_obstacle_collide(self)
		if disappear_on_collide:
			queue_free()
			
func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		body.on_obstacle_end_collide(self)
	pass
