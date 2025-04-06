extends Node2D

@export var texture_bg: CompressedTexture2D
@export var possibles_hairs: Array[PackedScene]
@export var nb_spawn_advance: int

var texture_y_size = 0.0
var next_spawn_pos = 0.0
var sprites: Array
var hairs: Array

func _ready() -> void:
	texture_y_size = texture_bg.get_height()

func _process(delta: float) -> void:
	var camera_y = get_viewport().get_camera_2d().get_screen_center_position().y
	if camera_y <= next_spawn_pos + texture_y_size:
		for i in range(nb_spawn_advance):
			var bg = Sprite2D.new()
			bg.z_index = -1
			bg.texture = texture_bg
			bg.position = Vector2(0.0, next_spawn_pos)
			add_child(bg)
			sprites.append(bg)
			
			var hair_rand_index_left = randi_range(0, possibles_hairs.size() -1)
			var hair_left = possibles_hairs[hair_rand_index_left].instantiate()
			hair_left.position = Vector2(GameManager.left_wall.global_position.x, next_spawn_pos)
			add_child(hair_left)
			hairs.append(hair_left)
			
			var hair_rand_index_right = randi_range(0, possibles_hairs.size() -1)
			var hair_right = possibles_hairs[hair_rand_index_right ].instantiate()
			hair_right.position = Vector2(GameManager.right_wall.global_position.x, next_spawn_pos)
			hair_right.scale *= -1
			add_child(hair_right)
			hairs.append(hair_right)
			next_spawn_pos -= texture_y_size
		while sprites.size() > nb_spawn_advance + 1:
			var index = 0
			sprites[index].queue_free()
			sprites.remove_at(index)
			hairs[index+1].queue_free()
			hairs[index].queue_free()
			hairs.remove_at(index + 1)
			hairs.remove_at(index)
