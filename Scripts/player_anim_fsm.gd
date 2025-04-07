class_name PlayerAnimFSM

extends AnimatedSprite2D

@onready var sprite_component:AnimatedSprite2D = $"."
@onready var hit_sprite_component:AnimatedSprite2D = $ColSprite

enum {IDLE, LOAD, lOAD_LOOP, LAUNCH, HIT}
var state = IDLE

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	change_state(IDLE)

	
func change_state(new_state) -> void:
	state = new_state
	match state:
		IDLE :
			sprite_component.play("default")
		LOAD :
			sprite_component.play("load")			
		lOAD_LOOP :
			sprite_component.play("load_loop")
		LAUNCH :
			sprite_component.play("launch")
		HIT: 
			


func _on_animation_finished() -> void:
	match state:
		IDLE :
			pass
		LOAD :
			change_state(lOAD_LOOP)			
		lOAD_LOOP :
			pass
		LAUNCH :
			change_state(IDLE)
