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
	##TODO FIX THIS FIND ANOTHER WAY YOU SHALL NOT PASS POLISH PHASE
	if button_pressed && Input.is_action_pressed("ui_accept"):
		text = "?"
		#release_focus()
	else:
		update_key_text()
		#grab_focus()

func _unhandled_input(event):
	#print(event)
	if event.is_action_pressed("Blue"):
		text = "B"
		send_note("B")
		#button_pressed = false
	if event.is_action_pressed("Red"):
		text = "R"
		send_note("R")
		#button_pressed = false
	if event.is_action_pressed("Green"):
		text = "G"
		send_note("G")
		#button_pressed = false
	if event.is_action_pressed("Yellow"):
		text = "Y"
		send_note("Y")
		#button_pressed = false
	if event.is_action_pressed("ui_cancel"):
		text = str(num)
		send_note(num)
		button_pressed = false
	if event.is_action("ui_accept"):
		button_pressed = false
		call_deferred("lose_focus")

func lose_focus():
	call_deferred("lose_focus2")
	button_pressed = false

func lose_focus2():
	button_pressed = false

func update_note(num):
	pass

func send_note(note):
	var note_data = {
		"note": note,
		"type": "P",
		"hold": 0
	}
	new_note.emit(note_data)

func update_key_text():
	#var aux = InputMap.action_get_events(note)[0].as_text()
	#text = "%s" % InputMap.action_get_events(note)[0].as_text()
	pass
