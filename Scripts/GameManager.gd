extends Node

@export var left_wall: Node2D
@export var right_wall: Node2D

var is_game_running: bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	retrieve_walls()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not left_wall:
		retrieve_walls()
	pass

func retrieve_walls():
	var left_walls = get_tree().get_nodes_in_group("wall_left")
	var right_walls = get_tree().get_nodes_in_group("wall_left")
	if left_walls.size() > 0:
		left_wall = left_walls[0]
	if right_walls.size() > 0:
		right_wall = right_walls[0]

func game_over():
	is_game_running = false
