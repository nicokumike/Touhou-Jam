extends TextureButton


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("mouse_entered", Callable(self, "_on_mouse_entered"))
	connect("mouse_exited", Callable(self, "_on_mouse_exited"))

func _on_mouse_entered():
	pivot_offset = self.size/2
	pivot_offset.x = self.size.x
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1.05, 1.05), .1)
	
func _on_mouse_exited():
	pivot_offset = self.size/2
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1, 1), .05)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
