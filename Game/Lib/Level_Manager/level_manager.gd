extends Node

class_name Level_Manager

@export var levels: Array[PackedScene] = []

# Called when the node enters the scene tree for the first time.
func _ready():
	print(levels[0])
	var new_level = levels[0].instantiate()
	add_child(new_level)
	pass # Replace with function body.
