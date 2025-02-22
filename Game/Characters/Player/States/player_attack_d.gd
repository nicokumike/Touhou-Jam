extends EntityState

func enter(previous_state_path: String, _data := {}) -> void:
	super.enter(previous_state_path, _data)
	animation_handler.animation_ended.connect(end_state)
	print("Entering Flandre Attack D")

func exit() -> void:
	animation_handler.animation_ended.disconnect(end_state)

func end_state(spine_sprite: Object, animation_state: Object, track_entry: Object) -> void:
	finished.emit("Idle")
