extends ProgressBar

@export var shake = 5.0
@export var shake_time = 0.5
@export var range_to_shake = 5.0

@onready var anim = $AnimBar

var begin_position: Vector2
var elapsed_time = 0.0
var last_value = 0.0
var is_shaking = false

func _ready() -> void:
	begin_position = position
	last_value = GameManager.current_fuel

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	value = GameManager.current_fuel
	
	if value > last_value:
		anim.play("add")
	elif abs(value - last_value) > range_to_shake:
		is_shaking = true
		elapsed_time = 0.0
	if is_shaking:
		elapsed_time += delta
		var shake = Vector2(randf_range(-shake, shake), randf_range(-shake, shake))
		position = begin_position + shake
		if elapsed_time > shake_time:
			is_shaking = false
	else:
		position = begin_position
	
	last_value = value
