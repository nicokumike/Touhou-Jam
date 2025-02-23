extends EntityState

func enter(previous_state_path: String, _data := {}) -> void:
	super.enter(previous_state_path, _data)
	animation_handler.animation_completed.connect(end_state)

func exit() -> void:
	animation_handler.animation_completed.disconnect(end_state)

func end_state(_spine_sprite: Object, _animation_state: Object, _track_entry: Object) -> void:
	if Input.is_action_pressed("Yellow") or Input.is_action_pressed("Blue") or Input.is_action_pressed("Green") or Input.is_action_pressed("Red"):
		finished.emit("Hold")
	else:
		finished.emit("Flying")
