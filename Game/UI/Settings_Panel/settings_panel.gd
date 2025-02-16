extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().paused = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_option_button_item_selected(index):
	if index == 0:
		DisplayServer.window_set_size(Vector2i(2560, 1440))
	elif index == 1:
		DisplayServer.window_set_size(Vector2i(1920, 1080))
	elif index == 2:
		DisplayServer.window_set_size(Vector2i(1440, 900))
	elif index == 3:
		DisplayServer.window_set_size(Vector2i(1366, 768))
	elif index == 4:
		DisplayServer.window_set_size(Vector2i(1280, 720))
		
		
