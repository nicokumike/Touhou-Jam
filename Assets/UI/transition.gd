extends Node2D


@export_enum("Fade_In", "Fade_Out") var fade: String
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _begin():
	if fade == "Fade_In":
		$AnimationPlayer.play("fade_in")
	else:
		$AnimationPlayer.play("fade_out")

func _on_animation_player_animation_finished(anim_name):
	SignalBus.emit.transition_finished(anim_name)
