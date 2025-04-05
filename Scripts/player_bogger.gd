extends CharacterBody2D

@export var gravity_mult_on_stick_wall: float = 0.3
@export var max_velocity_on_stick_wall: float = 20.0
@export var launch_force: float = 10000.0
@export var launch_feedback_node: Node2D
@export var min_size = 1.0
@export var max_size = 30.0
@export var time_scale_on_obstacle_hit: float = 0.2
@export var time_reduce_time_scale_on_obstacle_hit: float = 0.8
@export var up_velocity_on_obtacle_hit: float = -450.0

var current_size := 15:
	set(value):
		current_size = clamp(value, min_size, max_size)

var is_holding_click = false
var begin_hold_position = Vector2.ZERO
var current_launch_direction = Vector2.ZERO
var is_currently_on_wall = false
var is_affected_by_gravity = false

func _physics_process(delta: float) -> void:
	
	if is_on_wall() && !is_currently_on_wall:
		is_currently_on_wall = true
		is_affected_by_gravity = true
		velocity = Vector2.ZERO
	
	handle_gravity(delta)
		
	handle_inputs()
		
	launch_feedback_node.visible = is_holding_click && current_launch_direction != Vector2.ZERO;
	scale = Vector2.ONE * (current_size / 10.0)

	move_and_slide()

func add_size(size):
	current_size += size
	
func on_obstacle_collide():
	velocity = Vector2.ZERO
	velocity.y = up_velocity_on_obtacle_hit
	is_affected_by_gravity = true
	TimeScaleManager.set_time_scale_for_duration(time_scale_on_obstacle_hit
	 , time_reduce_time_scale_on_obstacle_hit)

func handle_gravity(delta: float):
	if is_currently_on_wall || is_affected_by_gravity:
		var gravity_mult: float = 1.0
		if(is_currently_on_wall):
			gravity_mult = gravity_mult_on_stick_wall
		velocity += get_gravity() * delta * gravity_mult
		if is_currently_on_wall && velocity.y >= max_velocity_on_stick_wall:
			velocity.y = max_velocity_on_stick_wall
			
func handle_inputs():
	if Input.is_action_just_pressed("click"):
		is_holding_click = true
		begin_hold_position = get_viewport().get_mouse_position()
		
	if Input.is_action_just_released("click"):
		is_holding_click = false
		velocity = current_launch_direction.normalized() * launch_force
		is_currently_on_wall = false
		is_affected_by_gravity = true
		
	if is_holding_click:
		var currentMousePos = get_viewport().get_mouse_position()
		current_launch_direction = begin_hold_position - currentMousePos
		var angle = Vector2.UP.angle_to(current_launch_direction.normalized())
		var angleDeg = rad_to_deg(angle)
		launch_feedback_node.rotation_degrees = angleDeg
