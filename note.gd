extends CharacterBody2D

var speed
var type = 0

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


func _on_area_2d_area_entered(area):
	if area.is_in_group("killzone"):
		queue_free()
