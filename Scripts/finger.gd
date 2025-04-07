class_name Finger

extends Area2D
	
@export var min_speed_inside_screen: float = 400.0
@export var max_speed_inside_screen: float = 700.0 

@export var min_speed_outside_screen: float = 600.0
@export var max_speed_outside_screen: float = 1100.0

@export var max_time_full_speed = 60.0

@export var distance_curve_out_screen: Curve
@export var max_down_distance: float = 20.0
@export var max_bot_cam_distance: float = 600.0
@onready var threshold_out_screen: Node2D = $OutOfScreenThreshold
@onready var threshold_max_speed: Node2D = $MaxSpeedThreshold

var elapsed_time_out_screen = 0.0
var last_distance_bot_cam = 0.0
var elapsed_total_time = 0.0

var current_inside_screen_speed: float:
	get:
		return lerp(min_speed_inside_screen, max_speed_inside_screen, elapsed_total_time / max_time_full_speed)

var current_outside_screen_speed: float:
	get:
		return lerp(min_speed_outside_screen, max_speed_outside_screen, elapsed_total_time / max_time_full_speed)

func _process(delta: float) -> void:
	if not GameManager.is_game_running:
		return
		
	var camera = get_viewport().get_camera_2d()
	if camera.is_moving && not is_node_on_screen(threshold_out_screen):
		var threshold_space = abs(global_position.y - threshold_out_screen.global_position.y)
		var cam_bot_pos = get_bottom_camera_world_pos()
		var down_distance = distance_curve_out_screen.sample(elapsed_time_out_screen) * max_down_distance
		var new_pos_y = cam_bot_pos + threshold_space + down_distance
		var new_bot_cam_dist = abs(cam_bot_pos - new_pos_y)
		if new_bot_cam_dist < last_distance_bot_cam:
			new_pos_y = cam_bot_pos + last_distance_bot_cam
		else:
			last_distance_bot_cam = new_bot_cam_dist
		global_position = Vector2(global_position.x, new_pos_y)
		elapsed_time_out_screen += delta
	else:
		elapsed_time_out_screen = 0.0

	#if not camera.is_moving:
	var speed = current_inside_screen_speed
	if not is_node_on_screen(threshold_max_speed):
		speed = current_outside_screen_speed
	var speed_on_frame = -1.0 * (speed * delta)
	global_position = Vector2(global_position.x, global_position.y + speed_on_frame)
	
	var cam_bot_pos = get_bottom_camera_world_pos()
	last_distance_bot_cam = clamp(abs(cam_bot_pos - global_position.y),0 , max_bot_cam_distance)

	elapsed_total_time += delta
	
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		GameManager.game_over()
		#GameManager.restart()
		
func is_node_on_screen(node: Node2D) -> bool:
	var camera = get_viewport().get_camera_2d()
	var zoom = camera.zoom
	var half_viewport_height = (get_viewport().get_visible_rect().size.y / zoom.y) / 2
	var y_cam_center = camera.get_screen_center_position().y
	var y_camera_min = y_cam_center - half_viewport_height
	var y_camera_max = y_cam_center + half_viewport_height
		
	if y_camera_min <= node.global_position.y && node.global_position.y <= y_camera_max:
		return true
	return false
	
func get_bottom_camera_world_pos() -> float:
	var camera = get_viewport().get_camera_2d()
	var zoom = camera.zoom
	var half_viewport_height = (get_viewport().get_visible_rect().size.y / zoom.y) / 2
	var y_cam_center = camera.get_screen_center_position().y
	return y_cam_center + half_viewport_height
	
func restart() -> void:
	global_position = Vector2(0.0, 2000.0)
	elapsed_time_out_screen = 0.0
	elapsed_total_time = 0.0
