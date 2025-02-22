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

# Get precision of note hit
func initiate(type) -> int:
	match type:
		0:
			anim.play("miss")
			#print("Note Precision:\t", type, "\t Miss")
			return type
		1:
			anim.play("bad")
			#print("Note Precision:\t", type, "\t Bad")
			return type
		2:
			anim.play("good")
			#print("Note Precision:\t", type, "\t Good")
			return type
		3:
			anim.play("great")
			#print("Note Precision:\t", type, "\t Great")
			return type
		4:
			anim.play("perfect")
			#print("Note Precision:\t", type, "\t Perfect")
			return type
			
	return -1
		
func _on_animation_player_animation_finished(anim_name):
	queue_free()
