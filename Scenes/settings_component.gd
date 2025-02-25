extends Control

var time = 3
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().paused = true
	$Label.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Label.text = str(time)


func _on_continue_button_pressed() -> void:
	#print("hi")
	$SettingsMenu.visible = false
	$Label.visible = true
	#print($Label.text)
	$Timer.start()
	


func _on_timer_timeout() -> void:
	print("timeout")
	if time > 0:
		time -= 1
		$Timer.start()
	else:
		print("queue")
		get_tree().paused = false
		queue_free()
