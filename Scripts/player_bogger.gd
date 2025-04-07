class_name Player

extends CharacterBody2D

@export var gravity_mult_on_stick_wall: float = 0.3
@export var gravity_mult: float = 1.0
@export var max_velocity_on_stick_wall: float = 20.0
@export var launch_force: float = 10000.0
@export var launch_feedback_node: Node2D
@export var time_scale_on_obstacle_hit: float = 0.2
@export var time_reduce_time_scale_on_obstacle_hit: float = 0.8
@export var up_velocity_on_obtacle_hit: float = -450.0
@export var stretch_curve_force:Curve
@export var min_stretch_force: float = 100.0
@export var max_stretch_force: float = 100.0
@export var fuel_consumption_by_seconds:float = 33.0
@export var min_scale:float = 2.0
@export var max_scale:float = 5.0
@export var time_with_no_consumption:float = 0.3

@export var min_scale_arrow = 0.1
@export var max_scale_arrow = 0.4

@export var velocity_detect_wall_threshold: float = 5.0

@onready var sprite_arrow: Node2D = $LaunchFeedbackDir/SpriteArrow
@onready var sprite_booger: Node2D = $PlayerSprite
@onready var raycast_left: RayCast2D = $RaycastLeft
@onready var raycast_right: RayCast2D = $RaycastRight

@onready var player_anim_fsm: PlayerAnimFSM = $PlayerSprite

var time_since_stretch = 0.0

var is_holding_click = false
var begin_hold_position = Vector2.ZERO
var current_launch_direction = Vector2.ZERO
var is_currently_on_wall = false
var is_affected_by_gravity = false
var just_restarted = false

var max_fuel_charge_time: float:
	get:
		return GameManager.max_fuel / fuel_consumption_by_seconds
		
var fuel_current_charge_time:float:
	get:
		return clamp((time_since_stretch - time_with_no_consumption) / max_fuel_charge_time, 0.0, 1.0)

func _ready() -> void:
	pass
	
func _process(delta:float) -> void:
	if just_restarted:
		just_restarted = false
		return
	handle_inputs(delta)
	
func _physics_process(delta: float) -> void:
	if not GameManager.is_game_running:
		return
		
	if (raycast_left.is_colliding() && velocity.x < -velocity_detect_wall_threshold) || (raycast_right.is_colliding() && velocity.x > velocity_detect_wall_threshold):
		play_impact_sfx()
		
	if is_on_wall() && !is_currently_on_wall:
		is_currently_on_wall = true
		is_affected_by_gravity = true
		velocity = Vector2.ZERO
		play_slide_sfx(true)
	
	handle_gravity(delta)
	
	if is_holding_click:
		launch_feedback_node.visible = current_launch_direction != Vector2.ZERO
		var arrow_scale = lerp(min_scale_arrow, max_scale_arrow, fuel_current_charge_time)
		arrow_scale = clamp(arrow_scale, min_scale_arrow, max_scale_arrow)
		sprite_arrow.global_scale = Vector2(arrow_scale, arrow_scale)
		if time_since_stretch > time_with_no_consumption:
			GameManager.current_fuel -= fuel_consumption_by_seconds * delta
			if GameManager.current_fuel == 0.0:
				launch_bogger()
	else:
		launch_feedback_node.visible = false
		
	var new_scale = lerp(min_scale, max_scale, GameManager.current_fuel_percentage)
	scale = Vector2(new_scale, new_scale)
	move_and_slide()
	
func on_obstacle_collide(obstacle: Obstacle):
	if obstacle.behavior == Obstacle.Behavior.SLOW:
		velocity = Vector2.ZERO
		is_affected_by_gravity = true
		is_currently_on_wall = true
	elif obstacle.behavior == Obstacle.Behavior.STOP:
		velocity = Vector2.ZERO
		velocity.y = up_velocity_on_obtacle_hit
		TimeScaleManager.set_time_scale_for_duration(time_scale_on_obstacle_hit
		 , time_reduce_time_scale_on_obstacle_hit)
		is_affected_by_gravity = true
		GameManager.last_hit_timer = 0.0
		(get_viewport().get_camera_2d() as BogeyCamera).start_big_shake()
		play_impact_sfx()
		
func on_obstacle_end_collide(obstacle: Obstacle) -> void:
	if obstacle.behavior == Obstacle.Behavior.SLOW:
		is_currently_on_wall = false

func handle_gravity(delta: float):
	if is_currently_on_wall || is_affected_by_gravity:
		var gravity_mult: float = gravity_mult
		if(is_currently_on_wall):
			gravity_mult = gravity_mult_on_stick_wall
		velocity += get_gravity() * delta * gravity_mult
		if is_currently_on_wall && velocity.y >= max_velocity_on_stick_wall:
			velocity.y = max_velocity_on_stick_wall
			
func handle_inputs(delta: float):
	if !GameManager.is_game_running:
		return
		
	if Input.is_action_just_pressed("click"):
		is_holding_click = true
		begin_hold_position = get_viewport().get_mouse_position()
		time_since_stretch = 0.0
		player_anim_fsm.change_state(player_anim_fsm.LOAD)
		play_stretch_sfx(true)
		#(get_viewport().get_camera_2d() as BogeyCamera).start_stretch_shake()

	if Input.is_action_just_released("click") && is_holding_click:
		launch_bogger()
		#(get_viewport().get_camera_2d() as BogeyCamera).stop_stretch_shake()
		
	if is_holding_click:
		var currentMousePos = get_viewport().get_mouse_position()
		current_launch_direction = begin_hold_position - currentMousePos
		var angle = Vector2.UP.angle_to(current_launch_direction.normalized())
		var angleDeg = rad_to_deg(angle)
		launch_feedback_node.rotation_degrees = angleDeg
		sprite_booger.rotation_degrees = angleDeg
		time_since_stretch += delta

func launch_bogger():
	if !GameManager.is_game_running:
		return
	is_holding_click = false
	var force = lerp(min_stretch_force, max_stretch_force, stretch_curve_force.sample(fuel_current_charge_time))
	velocity = current_launch_direction.normalized() * force
	is_currently_on_wall = false
	is_affected_by_gravity = true
	time_since_stretch = 0.0
	player_anim_fsm.change_state(player_anim_fsm.LAUNCH)
	play_stretch_sfx(false)
	$LaunchEventEmmiter.play()
	play_slide_sfx(false)
	
func launch_collect_event() -> void:
	$CollectEventEmmiter.play()
	
func play_stretch_sfx(play: bool) -> void:
	if play:
		$StretchEventEmmiter.play()
	else:
		$StretchEventEmmiter.stop()
		
func play_slide_sfx(play: bool) -> void:
	if play:
		$WallSlideEventEmmiter.play()
	else:
		$WallSlideEventEmmiter.stop()
		
func play_impact_sfx() -> void:
	$ImpactEventEmmiter.play()
	
func restart() -> void:
	global_position = Vector2.ZERO
	is_affected_by_gravity = false
	is_currently_on_wall = false
	is_holding_click = false
	just_restarted = true
	velocity = Vector2.ZERO
