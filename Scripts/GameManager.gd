extends Node

var left_wall: Node2D
var right_wall: Node2D
var player: Player
var gameover_menu: Control

var is_game_running: bool = true
var min_fuel = 0.0
var max_fuel = 100.0

var score_by_sec: int = 1
var combo_timer_secs: float = 5.0
var combo_timer_value: int = 5

var current_combo: int = 1
var current_score: float = 0.0
var last_hit_timer: float = 0.0
var highest_distance_player = 0.0

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
	retrieve_walls()
	retrieve_player()
	retrieve_game_over_menu()
	
	if last_hit_timer >= combo_timer_secs:
		current_combo = combo_timer_value
	else:
		current_combo = 1
	current_score += (score_by_sec * delta) * current_combo
	if player && abs(player.global_position.y) > highest_distance_player:
		highest_distance_player = abs(player.global_position.y)
	last_hit_timer += delta
	pass

func retrieve_walls():
	if not left_wall:
		var left_walls = get_tree().get_nodes_in_group("wall_left")
		var right_walls = get_tree().get_nodes_in_group("wall_right")
		if left_walls.size() > 0:
			left_wall = left_walls[0]
		if right_walls.size() > 0:
			right_wall = right_walls[0]
		
func retrieve_player():
	if not player:
		var player_node = get_tree().get_nodes_in_group("player")
		if player_node.size() > 0:
			player = player_node[0]
			
func retrieve_game_over_menu():
	var gameover_menu_node = get_tree().get_nodes_in_group("gameover")
	if gameover_menu_node.size() > 0:
		gameover_menu = gameover_menu_node[0]
			
func game_over() -> void:
	gameover_menu.visible = true
	is_game_running = false	
	
func restart() -> void:
	current_fuel = max_fuel / 2.0
	current_score = 0
	highest_distance_player = 0
	current_combo = 1
	last_hit_timer = 0.0
	get_tree().reload_current_scene()
	retrieve_walls()
	gameover_menu.visible = false
	is_game_running = true
