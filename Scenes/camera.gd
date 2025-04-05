extends Camera2D

@export var player_path: NodePath
@export var start_height_percentage_camera: float = 50.0
@export var max_height_percentage_camera: float = 95.0
@export var time_to_start_follow: float = 1.0
@export var ease_speed: float = 2.0

var player: Node2D
var should_move_up: bool = false
var elapsed_time: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_node(player_path)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not player:
		return
		
	
	
	var cam_pos = global_position
	if player.global_position.y < cam_pos.y:
		if !should_move_up:
			should_move_up = true
			elapsed_time = 0.0
		
		elapsed_time += delta
		if elapsed_time > time_to_start_follow:
			#var ease_time = (elapsed_time - time_to_start_follow) / max_ease_time
			var new_y_position = lerp(cam_pos.y, player.global_position.y, delta * ease_speed)
			global_position = Vector2(global_position.x, new_y_position)
			if new_y_position < player.global_position.y:
				should_move_up = false
	else:
		should_move_up = false
