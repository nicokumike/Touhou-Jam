extends Control

var color = 1.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Label.modulate = Color.from_hsv(color/359.0, 100.0/100.0, 100.0/100.0, 225.0/225.0)
	if color < 359.0:
		color += 1.0
	else:
		color = 0.0
	print(color)
