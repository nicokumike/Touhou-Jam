extends Node

#Turn off unused signal warning in project to get rid of the dumb warnings
#I KNOW WHAT IM DOING GODOT HECK OFF

# Signal that will be triggered when game pauses
signal pause_game

# Signal that will be triggered when game pauses
signal game_state_changed(new_state)

# Signal that will be triggered when dialogue starts
signal dialogue_triggered(dialogue_data: Dictionary)

# Signal that will be emitted when dialogue is complete
signal dialogue_finished
