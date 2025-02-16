extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	#get_tree().root.ContentScaleMode = 3
	#get_viewport().Scale
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on__x_720_pressed():
	DisplayServer.window_set_size(Vector2i(1280, 720))
	
func _on__x_900_pressed():
	DisplayServer.window_set_size(Vector2i(1440, 900))

func _on__x_768_pressed():
	DisplayServer.window_set_size(Vector2i(1366, 768))

func _on__x_1080_pressed():
	DisplayServer.window_set_size(Vector2i(1920, 1080))

func _on__x_1440_pressed():
	DisplayServer.window_set_size(Vector2i(2560, 1440))
