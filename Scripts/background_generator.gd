extends Node2D

@export var texture_bg: CompressedTexture2D
@export var nb_spawn_advance: int

var texture_y_size = 0.0
var next_spawn_pos = 0.0
var sprites: Array

func _ready() -> void:
	texture_y_size = texture_bg.get_height()

func _process(delta: float) -> void:
	var camera_y = get_viewport().get_camera_2d().get_screen_center_position().y
	if camera_y <= next_spawn_pos:
		for i in range(nb_spawn_advance):
			if sprites.size() >= nb_spawn_advance:
				for j in range(nb_spawn_advance):
					var index = nb_spawn_advance -1 - j
					sprites[index].queue_free()
					sprites.remove_at(index)
			var bg = Sprite2D.new()
			bg.z_index = -1
			bg.texture = texture_bg
			bg.position = Vector2(0.0, next_spawn_pos)
			if i < nb_spawn_advance - 2:
				next_spawn_pos -= texture_y_size
			add_child(bg)
			sprites.append(bg)
