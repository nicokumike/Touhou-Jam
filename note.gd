extends CharacterBody2D

var speed
var type = 0

var pointer : Vector2

func _ready():
	pass

func _process(delta):
	position.x -= speed * delta

func setSpeed(spd):
	speed = spd

func setColor(color):
	match (color):
		1:
			modulate = Color.YELLOW
			type = 1
			pass
		2:
			modulate = Color.BLUE
			type = 2
			pass
		3:
			modulate = Color.GREEN
			type = 3
			pass
		4:
			modulate = Color.RED
			type = 4
			pass
	pass

func checkPosition() -> int:
	if abs(position.x - pointer.x) <= 10:
		return 4 #Perfect
	if abs(position.x - pointer.x) <= 30:
		return 3 #Great
	if abs(position.x - pointer.x) <= 50:
		return 2 #Good
	if abs(position.x - pointer.x) <= 80:
		return 1 #Bad
	#If I didn't reach any of the previous distances, and the note is to
	#the left of the pointer, it means I missed.
	if position.x < pointer.x:
		return -1 #Miss
		
	return 0

func _on_hitbox_area_entered(area):
	if area.is_in_group("killzone"):
		queue_free()
