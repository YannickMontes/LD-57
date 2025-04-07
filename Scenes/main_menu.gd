class_name GameOverMenu
extends Control

@onready var start_button: MenuButton = $"VBoxContainer/Start Button" as Button
@onready var exit_button: MenuButton = $"VBoxContainer/Exit Button" as Button
@onready var start_level = preload("res://Scenes/game.tscn") as PackedScene


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_button.button_down.connect(on_start_pressed)
	exit_button.button_down.connect(on_exit_pressed)

func on_start_pressed() -> void:
	$Timer.start()
	$StartEventEmmiter.play()
	start_button.disabled = true
	exit_button.disabled = true
	
func on_exit_pressed() -> void:
	get_tree().quit()

func _on_timer_timeout() -> void:
	get_tree().change_scene_to_packed(start_level)
