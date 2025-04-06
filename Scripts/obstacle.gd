class_name Obstacle

extends Area2D

enum Behavior { STOP, SLOW }

@export var size_to_add: int
@export var disappear_on_collide: bool
@export var behavior: Behavior
@export var slow_percentage: float
var isPositive: bool

func _ready() -> void:
	isPositive = size_to_add > 0

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.add_size(size_to_add)
		if !isPositive:
			body.on_obstacle_collide(self)
		if disappear_on_collide:
			queue_free()
