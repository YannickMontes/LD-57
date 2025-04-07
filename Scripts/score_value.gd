extends Label

func _process(delta: float) -> void:
	text = str(int(GameManager.current_score))
