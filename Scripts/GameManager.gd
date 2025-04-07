extends Node

var left_wall: Node2D
var right_wall: Node2D
var player: Player
var finger: Finger
var gameover_menu: Control
var music_emmiter: FmodEventEmitter2D
var camera: Camera2D
var level_generator: LevelGenerator
var background_generator: BackgroundGenerator

var metal_combo_threshold = 5.0

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
var last_pos_player = Vector2.ZERO

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
	retrieve_music_emmiter()
	retrieve_finger()
	retrieve_camera()
	retrieve_level_generator()
	retrieve_background_generator()
	
	if not is_game_running:
		return
	
	#if last_hit_timer >= combo_timer_secs:
		#current_combo = combo_timer_value
		#if music_emmiter:
			#music_emmiter.set_parameter("mode", "metal")
	#else:
		#if music_emmiter:
			#music_emmiter.set_parameter("mode", "classic")
		#current_combo = 1
	
	if current_combo >= metal_combo_threshold:
		if music_emmiter:
			music_emmiter.set_parameter("mode", "metal")
	else:
		if music_emmiter:
			music_emmiter.set_parameter("mode", "classic")
			
	if player && player.global_position.y < last_pos_player.y && player.global_position.y < highest_distance_player:
		var delta_distance = abs(player.global_position.y - last_pos_player.y)
		var score_to_add = player.get_score(delta_distance)
		print(score_to_add)
		current_score += score_to_add

	last_hit_timer += delta
	if player:
		last_pos_player = player.global_position
		highest_distance_player = player.global_position.y
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
		
func retrieve_music_emmiter():
	var music_emmiter_node = get_tree().get_nodes_in_group("music")
	if music_emmiter_node.size() > 0:
		music_emmiter = music_emmiter_node[0]
		
func retrieve_finger():
	var finger_node = get_tree().get_nodes_in_group("finger")
	if finger_node.size() > 0:
		finger = finger_node[0]

func retrieve_camera():
	var camera_node = get_tree().get_nodes_in_group("camera")
	if camera_node.size() > 0:
		camera = camera_node[0]
		
func retrieve_level_generator():
	var level_generator_node = get_tree().get_nodes_in_group("level_generator")
	if level_generator_node.size() > 0:
		level_generator = level_generator_node[0]
		
func retrieve_background_generator():
	var background_generator_node = get_tree().get_nodes_in_group("background_generator")
	if background_generator_node.size() > 0:
		background_generator = background_generator_node[0]

func game_over() -> void:
	gameover_menu.visible = true
	is_game_running = false
	if current_combo > 1:
		music_emmiter.set_parameter("mode", "metal_slow")
	else:
		music_emmiter.set_parameter("mode", "classic_slow")
	
func restart() -> void:
	current_fuel = max_fuel / 2.0
	current_score = 0
	highest_distance_player = 0
	current_combo = 1
	last_hit_timer = 0.0
	#get_tree().reload_current_scene()
	retrieve_walls()
	if gameover_menu:
		gameover_menu.visible = false
	if player:
		player.restart()
	if finger:
		finger.restart()
	if camera:
		camera.restart()
	if level_generator:
		level_generator.restart()
	if background_generator:
		background_generator.restart()
	
	is_game_running = true
