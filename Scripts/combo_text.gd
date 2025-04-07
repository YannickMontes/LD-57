extends HSplitContainer

@export var max_scale = 1.2
@export var min_scale = 1.0
@export var time_up = 0.5

var elapsed_time = 0.0
var is_glowing = false
var is_growing = false

func _process(delta: float) -> void:
	set_is_glowing(GameManager.current_combo >= GameManager.metal_combo_threshold)
	if is_glowing:
		elapsed_time += delta
		if elapsed_time >= time_up:
			elapsed_time = 0.0
			is_growing = !is_growing
		var new_scale
		if is_growing:
			new_scale = lerp(min_scale, max_scale, elapsed_time / time_up)
		else:
			new_scale = lerp(max_scale, min_scale, elapsed_time / time_up)
		scale = Vector2(new_scale, new_scale)

func set_is_glowing(glowing: bool):
	if is_glowing == glowing:
		return;
	is_glowing = glowing
	is_growing = true
	elapsed_time = 0.0
	if not glowing:
		scale = Vector2(min_scale, min_scale)
