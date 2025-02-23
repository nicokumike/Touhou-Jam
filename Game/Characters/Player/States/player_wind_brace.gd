extends EntityState

func enter(previous_state_path: String, _data := {}) -> void:
	super.enter(previous_state_path, _data)

func update(_delta: float) -> void:
	if not Input.is_action_pressed("Yellow") and not Input.is_action_pressed("Blue") and not Input.is_action_pressed("Green") and not Input.is_action_pressed("Red"):
		finished.emit("Flying")
