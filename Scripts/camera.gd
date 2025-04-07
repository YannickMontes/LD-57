class_name BogeyCamera

extends Camera2D

@export var big_shake_strength = 20.0
@export var big_shake_fade = 0.2

@export var min_shake_stretch = 1.0
@export var max_shake_stretch = 1.0
@export var stretch_time = 2.0

@export var player_path: NodePath
@export var start_height_percentage_camera: float = 50.0
@export var max_height_percentage_camera: float = 95.0
@export var time_to_start_follow: float = 1.0
@export var ease_speed: float = 2.0
@export var min_speed_to_move = 5.0

var player: Node2D
var should_move_up: bool = false
var elapsed_time: float = 0.0
var is_moving = false

var shake_strength: float = 0.0
var elapsed_time_stretch_shake: float = 0.0

var is_shaking = false
var elapsed_time_shake: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_node(player_path)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not player:
		return
		
	handle_shake(delta)
	
	var cam_pos = global_position
	if player.global_position.y < cam_pos.y:
		if !should_move_up:
			should_move_up = true
			elapsed_time = 0.0
		
		elapsed_time += delta
		if elapsed_time > time_to_start_follow:
			#var ease_time = (elapsed_time - time_to_start_follow) / max_ease_time
			var new_y_position = lerp(cam_pos.y, player.global_position.y, delta * ease_speed)
			is_moving = abs(new_y_position) - abs(global_position.y) > min_speed_to_move
			global_position = Vector2(global_position.x, new_y_position)
			if new_y_position < player.global_position.y:
				should_move_up = false
	else:
		should_move_up = false
		
func handle_shake(delta: float):
	shake_strength = 0.0
	if is_shaking && GameManager.is_game_running:
		elapsed_time_shake += delta
		shake_strength = big_shake_strength
		if elapsed_time_shake >= big_shake_fade:
			is_shaking = false
	elif player.is_holding_click && GameManager.is_game_running:
		elapsed_time_stretch_shake += delta
		shake_strength = lerp(min_shake_stretch, max_shake_stretch, elapsed_time_stretch_shake / stretch_time)
	else:
		elapsed_time_shake = 0.0
		elapsed_time_stretch_shake = 0.0	
		
	offset = Vector2(randf_range(-shake_strength, shake_strength), randf_range(-shake_strength, shake_strength))

func start_big_shake() -> void:
	shake_strength = big_shake_strength
	elapsed_time_shake = 0.0
	is_shaking = true
	
func restart() -> void:
	global_position = Vector2.ZERO
	should_move_up = false;
	is_moving = false
	elapsed_time = 0.0
