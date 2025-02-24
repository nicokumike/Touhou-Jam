extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	$AnimationPlayer.play("fairy1")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	$Path2D3/PathFollow2D.progress_ratio = 0
