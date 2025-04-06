extends Area2D

@export var size_to_add: int
@export var disappear_on_collide: bool
var isPositive: bool

func _ready() -> void:
	isPositive = size_to_add > 0

func _on_body_entered(body: Node2D) -> void:
	body.add_size(size_to_add)
	if !isPositive:
		body.on_obstacle_collide()
	if disappear_on_collide:
		queue_free()
