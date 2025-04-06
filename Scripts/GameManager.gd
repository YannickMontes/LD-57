extends Node

@export var left_wall: Node2D
@export var right_wall: Node2D

var is_game_running: bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	left_wall = get_tree().get_nodes_in_group("wall_left")[0]
	right_wall = get_tree().get_nodes_in_group("wall_right")[0]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not left_wall:
		left_wall = get_tree().get_nodes_in_group("wall_left")[0]
		right_wall = get_tree().get_nodes_in_group("wall_right")[0]
	pass

func game_over():
	is_game_running = false
