extends Control

func _on_back_button_pressed() -> void:
	SignalBus.game_state_changed.emit("Main")
	queue_free()
