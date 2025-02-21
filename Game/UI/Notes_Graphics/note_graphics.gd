extends Node2D
var type = 0
@onready var anim = $AnimationPlayer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if type == 1:
		anim.play("miss")
	elif type == 2:
		anim.play("bad")
	elif type == 3:
		anim.play("good")
	else:
		anim.play("perfect")
		
