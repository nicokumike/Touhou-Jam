extends Node2D

@export var health = 100

var speed = 200
var targetPosition : Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if position.x > targetPosition.x:
		position.x -= speed * delta

func initiate(target):
	targetPosition = target
