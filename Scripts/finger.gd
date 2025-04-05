extends Area2D

@export var speed_inside_screen: float = 5.0 

@onready var threshold_screen: Node2D = $ThresholdScreen

func _process(delta: float) -> void:
	if not GameManager.is_game_running:
		return
		
	if is_threshold_on_screen():
		global_position = Vector2(global_position.x, global_position.y - speed_inside_screen * delta)
	else:
		var new_pos_y = get_bottom_camera_world_pos()
		global_position = Vector2(global_position.x, new_pos_y)
		
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		get_tree().reload_current_scene()
		
func is_threshold_on_screen() -> bool:
	var camera = get_viewport().get_camera_2d()
	var half_viewport_height = get_viewport().get_visible_rect().size.y / 2
	var y_cam_center = camera.get_screen_center_position().y
	var y_camera_min = y_cam_center - half_viewport_height
	var y_camera_max = y_cam_center + half_viewport_height
	
	if y_camera_min <= threshold_screen.global_position.y && threshold_screen.global_position.y <= y_camera_max:
		return true
	return false
	
func get_bottom_camera_world_pos() -> float:
	var camera = get_viewport().get_camera_2d()
	var half_viewport_height = get_viewport().get_visible_rect().size.y / 2
	var y_cam_center = camera.get_screen_center_position().y
	return y_cam_center + half_viewport_height
