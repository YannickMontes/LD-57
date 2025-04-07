class_name MainMenu
extends Control


@onready var exit_button: MenuButton = $texte/ExitButton
@onready var retry_button: MenuButton = $texte/RetryButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	retry_button.button_down.connect(on_restart_pressed)
	exit_button.button_down.connect(on_exit_pressed)

func on_restart_pressed() -> void:
	GameManager.restart()
	
func on_exit_pressed() -> void:
	get_tree().quit()
	
	
