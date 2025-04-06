extends Node

@export var left_wall: Node2D
@export var right_wall: Node2D

var is_game_running: bool = true
var min_fuel = 0.0
var max_fuel = 100.0

var current_fuel: float:
	set(value):
		current_fuel = clamp(value, min_fuel, max_fuel)

var current_fuel_percentage: float:
	get:
		return current_fuel / max_fuel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_fuel = max_fuel / 2.0
	retrieve_walls()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not left_wall:
		retrieve_walls()
	pass

func retrieve_walls():
	var left_walls = get_tree().get_nodes_in_group("wall_left")
	var right_walls = get_tree().get_nodes_in_group("wall_right")
	if left_walls.size() > 0:
		left_wall = left_walls[0]
	if right_walls.size() > 0:
		right_wall = right_walls[0]

func game_over() -> void:
	is_game_running = false
	
func restart() -> void:
	current_fuel = max_fuel / 2.0
	retrieve_walls()
	get_tree().reload_current_scene()
