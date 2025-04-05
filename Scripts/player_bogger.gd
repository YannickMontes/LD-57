extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const GRAVITY_WALL_MULTIPLIER = 40.0
const MAX_DOWN_VELOCITY = 10000.0
const LAUNCH_FORCE = 20000.0

@onready var launchFeedback = $LaunchFeedbackDir

var isHoldingClick = false
var beginHoldPosition = Vector2.ZERO
var currentLaunchDirection = Vector2.ZERO
var currentlyOnWall = false

func _physics_process(delta: float) -> void:
	
	if is_on_wall():
		if !currentlyOnWall:
			velocity = Vector2.ZERO
		velocity += get_gravity() * delta * GRAVITY_WALL_MULTIPLIER
		if velocity.y >= MAX_DOWN_VELOCITY:
			velocity.y = MAX_DOWN_VELOCITY
		currentlyOnWall = true
		print("on wall")
	else:
		currentlyOnWall = false
		#print("NOT on wall")
		
	if Input.is_action_just_pressed("click"):
		isHoldingClick = true
		beginHoldPosition = get_viewport().get_mouse_position()
	if Input.is_action_just_released("click"):
		isHoldingClick = false
		velocity = currentLaunchDirection.normalized() * LAUNCH_FORCE
		
	var angleDeg = 0.0
	if isHoldingClick:
		var currentMousePos = get_viewport().get_mouse_position()
		currentLaunchDirection = beginHoldPosition - currentMousePos
		var angle = Vector2.UP.angle_to(currentLaunchDirection.normalized())
		angleDeg = rad_to_deg(angle)
		launchFeedback.rotation_degrees = angleDeg
		
	launchFeedback.visible = isHoldingClick && currentLaunchDirection != Vector2.ZERO;

	move_and_slide()
	
