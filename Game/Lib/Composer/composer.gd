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
	initialize(music_sheet)
	pass # Replace with function body.

func initialize(data):
	var json_as_text = FileAccess.get_file_as_string(data)
	var sheet_data = JSON.parse_string(json_as_text)
	bpm = sheet_data.bpm
	song_path = sheet_data.song
	song_name = sheet_data.name
	sheet = sheet_data.sheet
	prints(bpm, song_path, song_name, sheet)
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

func play_note():
	#Grab the note data
	var note = sheet[index[0]][index[1]][index[2]]
	var note_data
	print(note)
	if note is not float:
		prints("play note:", note)
		pass
	#Map it out according to our legend
	#Build the note projectile
	#Tell the emitter to emit the note
	
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
