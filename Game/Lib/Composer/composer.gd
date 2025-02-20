extends Node
class_name Composer

@export var emitter: Node
@export_file("*.json") var music_sheet = "res://Game/Lib/Composer/Music_Sheets/debugsheet.json"

var bpm
var song_path
var song_name
var sheet
var index = [0,0,0]

var legend = {
	"R" = "Red",
	"B" = "Blue",
	"G" = "Green",
	"Y" = "Yellow",
	"H" =  "Hold",
	"P" = "Projectile",
	"F" = "Fairy",
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#print(music_sheet.name)
	#initialize(music_sheet)
	pass # Replace with function body.

func initialize():
	var json_as_text = FileAccess.get_file_as_string(music_sheet)
	var sheet_data = JSON.parse_string(json_as_text)
	bpm = sheet_data.bpm
	emitter.bpm = bpm
	song_path = sheet_data.song
	emitter.music = load(song_path)
	song_name = sheet_data.name
	sheet = sheet_data.sheet
	
	prints(bpm, song_path, emitter.music, song_name, sheet)
	print('------------------')
	#print_it_all()

#Debug function
func print_it_all():
	#Prints all the shit
	for measure in sheet:
		#print(measure, 'TEST')
		for beat in measure:
			#print(beat)
			for note in beat:
				#prints("current note", note)
				play_note()
	print("final index, ", index)

func decipher_note(note):
	var new_note = {
		"color": null,
		"hold": false,
		"length": 0,
		"type": null
	}
	match note[0]:
		"R": new_note.color = legend[note[0]]
		"G": new_note.color = legend[note[0]]
		"B": new_note.color = legend[note[0]]
		"Y": new_note.color = legend[note[0]]
	match note[1]:
		"H": 
			new_note.hold = true
			new_note.length = note[2]
	match note[-1]:
		"P": new_note.type = legend[note[1]]
		"F": new_note.type = legend[note[1]]
	#print(new_note)
	return new_note

func play_note():
	#Grab the note data
	var note = sheet[index[0]][index[1]][index[2]]
	var note_data = null
	#print(note)
	if note is not float:
		#prints("play note:", note)
		#Map it out according to our legend
		note_data = decipher_note(note)
	#Build the note projectile
	#Tell the emitter to emit the note
	if note_data != null:
		#print(note_data)
		emitter.emit_note(note_data)
	
	#Iterate the index
	index[2] += 1
	if index[2] == 4:
		index[1] += 1
		index[2] = 0
	if index[1] == 4:
		index[0] += 1
		index[1] = 0
	#print("index = ", index)
	#If it's the end of the song send a finished signal or use the emitter
	pass
