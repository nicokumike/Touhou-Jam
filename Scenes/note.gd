extends CharacterBody2D

var speed
var bpm
var type = 0
var is_fairy = false

@onready var holdTrail = $HoldTrail
var hold = false
var holdTime = 0
var holding = false
var holdTrailWidth

var pointer : Vector2
var pointerObj = null

@onready var animPlayer = $AnimationPlayer
var dead = false
var hit = false

@onready var contactPoint = $EnemyContactPoint
@onready var enemyPointArrow = $EnemyPointArrow
@onready var sprite = $Path2D/PathFollow2D/Icon

func _ready():
	if hold:
		holdTrail.visible = true
		var holdSize = speed * (bpm / 16.0 / 60.0) * holdTime / 2
		holdTrail.scale.x = (1.0 * holdSize) / holdTrail.texture.get_width()
		holdTrailWidth = holdTrail.texture.get_width() * holdTrail.scale.x
	pass

func _process(delta):
	if !holding:
		position.x -= speed * delta
	else:
		holdTrail.position.x -= speed * delta
		if holdTrail.global_position.x + holdTrailWidth <= pointer.x:
			pointerObj.releaseNote()
			queue_free()
	contactPoint.rotation_degrees -= .5

func setColor(color):
	var tween = create_tween()
	match (color):
		1:
			#yellow
			tween.tween_property(enemyPointArrow, "rotation_degrees", 270, 0)
			enemyPointArrow.modulate = Color.YELLOW
			sprite.material.set("shader_parameter/starting_colour", Vector4(1, 1, 0, 1))
			sprite.material.set("shader_parameter/ending_colour", Vector4(1, 1, 0, 0))
			type = 1
			pass
		2:
			#blue
			enemyPointArrow.modulate = Color.BLUE
			tween.tween_property(enemyPointArrow, "rotation_degrees", 180, 0)
			sprite.material.set("shader_parameter/starting_colour", Vector4(0, 0, 1, 1))
			sprite.material.set("shader_parameter/ending_colour", Vector4(0, 0, 1, 0))
			type = 2
			pass
		3:
			#green
			enemyPointArrow.modulate = Color.GREEN
			tween.tween_property(enemyPointArrow, "rotation_degrees", 90, 0)
			sprite.material.set("shader_parameter/starting_colour", Vector4(0, 1, 0, 1))
			sprite.material.set("shader_parameter/ending_colour", Vector4(0, 1, 0, 0))
			type = 3
			pass
		4:
			#red
			enemyPointArrow.modulate = Color.RED
			tween.tween_property(enemyPointArrow, "rotation_degrees", 360, 0)
			sprite.material.set("shader_parameter/starting_colour", Vector4(1, 0, 0, 1))
			sprite.material.set("shader_parameter/ending_colour", Vector4(1, 0, 0, 0))
			type = 4
			pass
	pass

func checkPosition() -> int:
	if abs(position.x - pointer.x) <= 10:
		return 4 #Perfect
	if abs(position.x - pointer.x) <= 20:
		return 3 #Great
	if abs(position.x - pointer.x) <= 40:
		return 2 #Good
	if abs(position.x - pointer.x) <= 60:
		return 1 #Bad
	#If I didn't reach any of the previous distances, and the note is to
	#the left of the pointer, it means I missed.
	if position.x < pointer.x:
		return -1 #Miss
		
	return 0
	
func holdNote():
	sprite.global_position = pointer
	holding = true

func releaseNote():
	queue_free()

func _on_hitbox_area_entered(area):
	if area.is_in_group("killzone"):
		queue_free()

func _on_animation_player_animation_finished(anim_name):
	if "anim_name" == "death":
		queue_free()
