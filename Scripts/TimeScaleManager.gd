extends Node

var default_time_scale: float = 1.0
var lerp_time: float = 0.2 

var target_scale: float = 1.0
var begin_scale: float = 1.0
var elapsed_time: float = 0.0
var has_duration: bool = false
var is_changing_scale: bool = false
var duration_time: float = 0.0

func _process(delta):
	if is_changing_scale:
		var real_sec_delta = delta / Engine.time_scale
		elapsed_time += real_sec_delta
		
		if elapsed_time <= lerp_time:
			Engine.time_scale = lerp(begin_scale, target_scale, elapsed_time)
		
		if has_duration && elapsed_time >= duration_time:
			is_changing_scale = false
			reset_time_scale()

# --- Public API ---

# Smoothly change time scale without auto-reset
func set_time_scale(scale: float) -> void:
	is_changing_scale = false
	Engine.time_scale = scale

# Smoothly change time scale and auto-reset after 'duration' seconds
func set_time_scale_for_duration(scale: float, duration: float) -> void:
	target_scale = scale
	has_duration = true
	duration_time = duration
	elapsed_time = 0.0
	is_changing_scale = true

# Instantly reset time scale back to default
func reset_time_scale() -> void:
	is_changing_scale = false
	Engine.time_scale = default_time_scale
