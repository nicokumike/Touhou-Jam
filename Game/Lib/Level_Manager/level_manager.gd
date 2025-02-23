extends Node

class_name Level_Manager

@export var levels: Array[PackedScene] = []

var curr_level = null
var curr_level_index = -1

# Called when the node enters the scene tree for the first time.
#func _ready():
	#print(levels[0])
	#var new_level = levels[0].instantiate()
	#add_child(new_level)
	#curr_level = new_level
	#pass # Replace with function body.

#Go to a specific level
func changeLevel(index):
	if curr_level != null:
		curr_level.queue_free()
	curr_level_index = index
	var new_level = levels[index].instantiate()
	add_child(new_level)
	curr_level = new_level

#Go to the next level
func nextLevel():
	if curr_level != null:
		curr_level.queue_free()
	curr_level_index += 1
	var new_level = levels[curr_level_index].instantiate()
	add_child(new_level)
	curr_level = new_level
