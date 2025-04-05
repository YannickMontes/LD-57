extends CharacterBody2D

const GRAVITY_WALL_MULTIPLIER = 1.0
const MAX_DOWN_VELOCITY = 1500.0
const LAUNCH_FORCE = 10000.0

@onready var launchFeedback = $LaunchFeedbackDir

var currentSize := 10:
	set(value):
		currentSize = clamp(value, 0, 30)

var isHoldingClick = false
var beginHoldPosition = Vector2.ZERO
var currentLaunchDirection = Vector2.ZERO
var isOnWall = false
var affectedByGravity = false

func _physics_process(delta: float) -> void:
	
	if is_on_wall() && !isOnWall:
		isOnWall = true
		velocity = Vector2.ZERO
		
	if affectedByGravity:
		velocity += get_gravity() * delta * GRAVITY_WALL_MULTIPLIER
		if velocity.y >= MAX_DOWN_VELOCITY:
			velocity.y = MAX_DOWN_VELOCITY
		
	if Input.is_action_just_pressed("click"):
		isHoldingClick = true
		beginHoldPosition = get_viewport().get_mouse_position()
	if Input.is_action_just_released("click"):
		isHoldingClick = false
		velocity = currentLaunchDirection.normalized() * LAUNCH_FORCE
		isOnWall = false
		affectedByGravity = false
		
	if isHoldingClick:
		var currentMousePos = get_viewport().get_mouse_position()
		currentLaunchDirection = beginHoldPosition - currentMousePos
		var angle = Vector2.UP.angle_to(currentLaunchDirection.normalized())
		var angleDeg = rad_to_deg(angle)
		launchFeedback.rotation_degrees = angleDeg
		
	launchFeedback.visible = isHoldingClick && currentLaunchDirection != Vector2.ZERO;
	scale = Vector2.ONE * (currentSize / 10.0)

	move_and_slide()

func add_size(size):
	currentSize += size
	
func on_obstacle_collide():
	velocity = Vector2.ZERO
	velocity.y = -450.0
	affectedByGravity = true
	TimeScaleManager.set_time_scale_for_duration(0.2, 0.8)
