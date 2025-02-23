## StateMachine design pattern adapted from GDQuest: https://www.gdquest.com/tutorial/godot/design-patterns/finite-state-machine/
class_name StateMachine extends Node

## The first child node of the state machine is used as the initial state if not set.
@export var initial_state: State
@onready var current_state: State = (func get_initial_state() -> State:
	return initial_state if initial_state != null else get_child(0)
).call()

func _ready():
	# Give every state a reference to the state machine.
	for state_node: State in find_children("*", "State"):
		state_node.finished.connect(set_state)

	# Wait for the owner to be ready before entering the initial state.
	await owner.ready
	current_state.enter("")
	pass

func _process(delta):
	if current_state:
		current_state.update(delta)
	pass

## Changes the current state to the one at the given path.
##
## @param target_state_path: The path to the state to change to.
## @param data: The data to pass to the new state.
func set_state(target_state_path: String, data := {}) -> void:
	if not has_node(target_state_path):
		printerr(owner.name + ": " + target_state_path + " is not a valid state path.")
		return

	var previous_state_path: String = current_state.name;
	current_state.exit()
	current_state = get_node(target_state_path)
	current_state.enter(previous_state_path, data)
