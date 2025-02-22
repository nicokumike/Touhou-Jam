extends Button
class_name RemapNoteButton

#@export var note: String = "Bluh"
var note = {
	"key": null,
	"type": "P",
	"hold": 0,
	"text": null
}

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
		update_note("B")
	if event.is_action_pressed("Red"):
		update_note("R")
	if event.is_action_pressed("Green"):
		update_note("G")
	if event.is_action_pressed("Yellow"):
		update_note("Y")
	if event.is_action_pressed("ui_cancel"):
		reset_note()
	if event.is_action_pressed("fairy"):
		update_note("F")
		pass
	if event.is_action("ui_accept"):
		button_pressed = false
		#call_deferred("lose_focus")

#func lose_focus():
	#call_deferred("lose_focus2")
	#button_pressed = false
#
#func lose_focus2():
	#button_pressed = false

func reset_note():
	note = {
		"key": null,
		"type": "P",
		"hold": 0,
		"text": null
	}
	text = str(num)
	send_note()
	button_pressed = false
	#print(note)

func update_note(param):
	#note = {
	#}
	match param:
		"B", "R", "G", "Y":
			setColor(param)
			note.key = param
	
	note.key = str(note.key + note.type)
	text = note.key
	#pass

func send_note():
	#var note_data = {
		#"note": note,
		#"type": "P",
		#"hold": 0
	#}
	new_note.emit(note)

func update_key_text():
	#var aux = InputMap.action_get_events(note)[0].as_text()
	#text = "%s" % InputMap.action_get_events(note)[0].as_text()
	pass

func setColor(color):
	match (color):
		"Y":
			modulate = Color.YELLOW
			#type = 1
			pass
		"B":
			modulate = Color.BLUE
			#type = 2
			pass
		"G":
			modulate = Color.GREEN
			#type = 3
			pass
		"R":
			modulate = Color.RED
			#type = 4
			pass
	pass
