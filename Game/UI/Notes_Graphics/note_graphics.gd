extends Node2D

var type = 0
@onready var anim = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#if type == 1:
		#anim.play("miss")
	#elif type == 2:
		#anim.play("bad")
	#elif type == 3:
		#anim.play("good")
	#elif type == 4:
		#anim.play("great")
	#else:
		#anim.play("perfect")
		
func initiate(type):
	match type:
		0:
			anim.play("miss")
		1:
			anim.play("bad")
		2:
			anim.play("good")
		3:
			anim.play("great")
		4:
			anim.play("perfect")
		
func _on_animation_player_animation_finished(anim_name):
	queue_free()
