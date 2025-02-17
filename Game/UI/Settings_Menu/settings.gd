extends Control


#func _on_option_button_item_selected(index):
	#if index == 0:
		#DisplayServer.window_set_size(Vector2i(2560, 1440))
	#elif index == 1:
		#DisplayServer.window_set_size(Vector2i(1920, 1080))
	#elif index == 2:
		#DisplayServer.window_set_size(Vector2i(1440, 900))
	#elif index == 3:
		#DisplayServer.window_set_size(Vector2i(1366, 768))
	#elif index == 4:
		#DisplayServer.window_set_size(Vector2i(1280, 720))

func _on_back_button_pressed() -> void:
	SignalBus.game_state_changed.emit("Main")
	queue_free()

func _on_master_slider_value_changed(value: float) -> void:
	pass # Replace with function body.


func _on_master_slider_drag_ended(value_changed: bool) -> void:
	pass # Replace with function body.


func _on_music_slider_value_changed(value):
	pass # Replace with function body.


func _on_music_slider_drag_ended(value_changed):
	pass # Replace with function body.


func _on_voice_slider_value_changed(value):
	pass # Replace with function body.


func _on_voice_slider_drag_ended(value_changed):
	pass # Replace with function body.


func _on_sfx_slider_value_changed(value):
	pass # Replace with function body.


func _on_sfx_slider_drag_ended(value_changed):
	pass # Replace with function body.
