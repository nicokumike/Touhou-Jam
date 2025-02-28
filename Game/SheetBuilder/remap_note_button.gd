extends Button
class_name RemapNoteButton

#@export var note: String = "Bluh"
var note = {
	"key": null,
	"type": "P",
	"hold": null,
	"text": null,
	"index": [beat, num]
}

@export var num: int
@export var beat: int

signal new_note

var color = Color.WHITE

func _init():
	toggle_mode = true
	theme_type_variation = "RemapButton"
	

func _ready():
	set_process_unhandled_input(false)
	if !(num % 2):
		color = Color.LIGHT_SLATE_GRAY
		modulate = color

func reset_color():
	modulate = color
	pass


func _toggled(new_button_pressed):
	set_process_unhandled_input(new_button_pressed)
	##TODO FIX THIS FIND ANOTHER WAY YOU SHALL NOT PASS POLISH PHASE
	if button_pressed && Input.is_action_pressed("ui_accept"):
		#text = "?"
		#release_focus()
		pass
	else:
		#update_key_text()
		#grab_focus()
		pass

func load_note(data):
	#print(data)
	text = str(data)
	for param in data:
		if param is not float:
			update_note(str(param))

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
	if event.is_action_pressed("projectile"):
		update_note("P")
#There's a better way to do this but we're low on time and brain juice
	if event.is_action_pressed("0"):
		update_note("0")
	if event.is_action_pressed("1"):
		update_note("1")
	if event.is_action_pressed("2"):
		update_note("2")
	if event.is_action_pressed("3"):
		update_note("3")
	if event.is_action_pressed("4"):
		update_note("4")
	if event.is_action_pressed("5"):
		update_note("5")
	if event.is_action_pressed("6"):
		update_note("6")
	if event.is_action_pressed("7"):
		update_note("7")
	if event.is_action_pressed("8"):
		update_note("8")
	if event.is_action_pressed("9"):
		update_note("9")
	#This is janky
	if event.is_action("ui_accept"):
		button_pressed = false
		if event.is_action_pressed("ui_accept"):
			send_note()

func reset_note():
	note = {
		"key": null,
		"type": "P",
		"hold": null,
		"text": num,
		"index": [beat, num]
	}
	text = str(num)
	send_note()
	button_pressed = false
	modulate = Color.WHITE

func update_note(param):
	match param:
		"B", "R", "G", "Y":
			setColor(param)
			note.key = param
		"0", "1", "2", "3", "4", "5", "6", "7", "8", "9":
			if note.hold == null:
				note.hold = str(param)
			else:
				note.hold = str(note.hold, param)
		"P", "F":
			note.type = param
	if note.hold != null:
		note.text = str(note.key,"H", note.hold, note.type)
	else:
		note.text = str(note.key, note.type)
	text = note.text
	note.index = [beat, num]

func send_note():
	#print(num, beat)
	#print(note)
	new_note.emit(note)

#func update_key_text():
	##var aux = InputMap.action_get_events(note)[0].as_text()
	##text = "%s" % InputMap.action_get_events(note)[0].as_text()
	#pass

func setColor(new_color):
	match (new_color):
		"Y":
			color = Color.YELLOW
			modulate = color
			#type = 1
		"B":
			color = Color.BLUE
			modulate = color
			#type = 2
		"G":
			color = Color.GREEN
			#modulate = Color.GREEN
			modulate = color
			#type = 3
		"R":
			color = Color.RED
			#modulate = Color.RED
			modulate = color
			#type = 4
	#print(color)
