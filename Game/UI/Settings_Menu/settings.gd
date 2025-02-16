extends Control

func _on_back_button_pressed() -> void:
	SignalBus.game_state_changed.emit("Main")
	queue_free()


func _on_master_slider_value_changed(value: float) -> void:
	pass # Replace with function body.


func _on_master_slider_drag_ended(value_changed: bool) -> void:
	pass # Replace with function body.
