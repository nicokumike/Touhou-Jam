extends CharacterBody2D

var speed
var bpm
var type = 0

@onready var holdTrail = $HoldTrail
var hold = false
var holdTime = 0
var holding = false
var holdTrailWidth

var pointer : Vector2
var pointerObj = null

@onready var contactPoint = $EnemyContactPoint
@onready var sprite = $Icon

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
	match (color):
		1:
			sprite.modulate = Color.YELLOW
			type = 1
			pass
		2:
			sprite.modulate = Color.BLUE
			type = 2
			pass
		3:
			sprite.modulate = Color.GREEN
			type = 3
			pass
		4:
			sprite.modulate = Color.RED
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
