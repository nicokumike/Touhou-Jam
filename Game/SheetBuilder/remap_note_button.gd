extends Button
class_name RemapNoteButton

@export var note: String = "Bluh"
@export var num: String

signal new_note

func _init():
	toggle_mode = true
	theme_type_variation = "RemapButton"

func _ready():
	set_process_unhandled_input(false)
	#update_key_text()

func _toggled(new_button_pressed):
	set_process_unhandled_input(new_button_pressed)
	if button_pressed:
		text = "?"
		#release_focus()
	else:
		update_key_text()
		#grab_focus()

func _unhandled_input(event):
	if event.is_action_pressed("Blue"):
		text = "Blue"
		button_pressed = false
	if event.is_action_pressed("Red"):
		text = "Red"
		button_pressed = false
		pass
	if event.is_action_pressed("Green"):
		text = "Green"
		button_pressed = false
	if event.is_action_pressed("Yellow"):
		text = "Yellow"
		button_pressed = false
	if event.is_action_pressed("ui_cancel"):
		text = num



func update_key_text():
	#var aux = InputMap.action_get_events(note)[0].as_text()
	#text = "%s" % InputMap.action_get_events(note)[0].as_text()
	pass
