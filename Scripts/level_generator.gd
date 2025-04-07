class_name LevelGenerator

extends Node2D

@export var bonus_node: PackedScene
@export var obstacle_node: PackedScene
@export var possible_wall_obstacles: Array[PackedScene]
@export var bonus_spawn_interval: Vector2
@export var obstacle_spawn_interval: Vector2
@export var wall_obstacles_interval: Vector2
@export var obstacles_range_x_percentage: float
@export var bonus_range_x_percentage: float
@export var advance_generation: float

var elements_spawned: Array[Node2D]
var next_y_spawn_pos: float = 0.0

func _process(delta: float) -> void:
	var y_top_camera = get_viewport().get_camera_2d().global_position.y - get_viewport_rect().size.y / 2.0
	if y_top_camera <= next_y_spawn_pos + (advance_generation / 2):
		generate()

func generate() -> void:
	generate_wall_obstacles()
	generate_obstacles()
	generate_bonuses()
	next_y_spawn_pos -= advance_generation
	
func generate_wall_obstacles() -> void:
	var current_generation_pos = next_y_spawn_pos
	while current_generation_pos > next_y_spawn_pos - advance_generation:
		var random_wall_obstacle_y = randf_range(wall_obstacles_interval.x, wall_obstacles_interval.y)
		var rand_wall_index = randi_range(0, possible_wall_obstacles.size() - 1)
		var rand_wall_side = randi_range(0,1)
		var wall_obstacle = possible_wall_obstacles[rand_wall_index].instantiate()
		var x_scale = wall_obstacle.scale.x
		var x_spawn = GameManager.left_wall.global_position.x
		if rand_wall_side == 1:
			x_scale *= -1.0
			x_spawn = GameManager.right_wall.global_position.x
		add_child(wall_obstacle)
		current_generation_pos -= random_wall_obstacle_y
		wall_obstacle.global_position = Vector2(x_spawn, current_generation_pos)
		wall_obstacle.scale = Vector2(x_scale, wall_obstacle.scale.y)
		elements_spawned.push_back(wall_obstacle)

func generate_obstacles() -> void:
	var current_generation_pos = next_y_spawn_pos
	while current_generation_pos > next_y_spawn_pos - advance_generation:
		var left_min_x = obstacles_range_x_percentage * GameManager.left_wall.global_position.x
		var left_max_x = obstacles_range_x_percentage * GameManager.right_wall.global_position.x
		var y_spawn = randf_range(obstacle_spawn_interval.x, obstacle_spawn_interval.y)
		var x_spawn = randf_range(left_min_x, left_max_x)
		var obstacle = obstacle_node.instantiate()
		add_child(obstacle)
		current_generation_pos -= y_spawn
		obstacle.global_position = Vector2(x_spawn, current_generation_pos)
		elements_spawned.push_back(obstacle)

func generate_bonuses() -> void:
	var current_generation_pos = next_y_spawn_pos
	while current_generation_pos > next_y_spawn_pos - advance_generation:
		var left_min_x = bonus_range_x_percentage * GameManager.left_wall.global_position.x
		var left_max_x = bonus_range_x_percentage * GameManager.right_wall.global_position.x
		var y_spawn = randf_range(bonus_spawn_interval.x, bonus_spawn_interval.y)
		var x_spawn = randf_range(left_min_x, left_max_x)
		var bonus = bonus_node.instantiate()
		add_child(bonus)
		current_generation_pos -= y_spawn
		bonus.global_position = Vector2(x_spawn, current_generation_pos)
		elements_spawned.push_back(bonus)

func restart() -> void:
	next_y_spawn_pos = 0.0
	while elements_spawned.size() > 0:
		if elements_spawned[0]:
			elements_spawned[0].queue_free()
		elements_spawned.remove_at(0)
