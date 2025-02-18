class_name State extends Node

## Signal emitted when the state has finished.
signal finished(next_state_path: String, data: Dictionary)

## Called by the state machine when receiving unhandled inputs.
func handle_input(_event: InputEvent) -> void:
	pass

## Called by the state machine when entering the state.
## The data parameter is used to initialize the state with any necessary information.
func enter(_previous_state_path: String, _data := {}) -> void:
	pass

## Called by the state machine when exiting the state.
func exit() -> void:
	pass

## Called by the state machine every frame.
func update(_delta: float) -> void:
	pass

## Called by the state machine every physics frame.
func physics_update(_delta: float) -> void:
	pass
