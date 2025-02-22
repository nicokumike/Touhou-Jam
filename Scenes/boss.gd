extends Node2D

@export var health := 1000

var speed = 100
var targetPosition : Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if position.x > targetPosition.x - 40:
		position.x -= speed * delta

func initiate(target):
	targetPosition = target

func take_damage(amount : int):
	health -= amount
	if health <= 0:
		#SignalBus.dialogue_triggered.emit(json_data.data)
		pass
