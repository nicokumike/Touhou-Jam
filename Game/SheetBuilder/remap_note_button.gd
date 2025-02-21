extends Button
class_name RemapNoteButton

@export var note: String = "Bluh"
@export var num: int
@export var beat: int

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
		text = "B"
		send_note("B")
		button_pressed = false
	if event.is_action_pressed("Red"):
		text = "R"
		send_note("R")
		button_pressed = false
	if event.is_action_pressed("Green"):
		text = "G"
		send_note("G")
		button_pressed = false
	if event.is_action_pressed("Yellow"):
		text = "Y"
		send_note("Y")
		button_pressed = false
	if event.is_action_pressed("ui_cancel"):
		text = str(num)
		send_note(num)
		button_pressed = false

func send_note(note):
	new_note.emit(note)

func update_key_text():
	#var aux = InputMap.action_get_events(note)[0].as_text()
	#text = "%s" % InputMap.action_get_events(note)[0].as_text()
	pass
