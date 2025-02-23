extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_fairy_1_timeout() -> void:
	$fairy1.play("fairy1")


func _on_fairy_1_animation_finished(anim_name: StringName) -> void:
	$Path2D/PathFollow2D.progress_ratio = 0
	


func _on_fairy_2_timeout() -> void:
	$fairy2.play("fairy")


func _on_fairy_2_animation_finished(anim_name: StringName) -> void:
	$Path2D2/PathFollow2D.progress_ratio = 0


func _on_fairy_3_timeout() -> void:
	$fairy3.play("fairy3")


func _on_fairy_3_animation_finished(anim_name: StringName) -> void:
	$Path2D3/PathFollow2D.progress_ratio = 0
