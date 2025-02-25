extends Control

var music = preload("res://Assets/Music/TSR_PRESS_START.mp3")
var color = 1.0

func _ready():
	AudMan.play_music(music, -15)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Label.modulate = Color.from_hsv(color/359.0, 100.0/100.0, 100.0/100.0, 225.0/225.0)
	if color < 359.0:
		color += 1.0
	else:
		color = 0.0
	print(color)
	
	if Input.is_anything_pressed():
		SignalBus.game_state_changed.emit("Main")
		queue_free()
