extends Node
class_name Composer

@export var emitter: Node
@export_file("*.json") var music_sheet = "res://Game/Lib/Composer/Music_Sheets/debugsheet.json"

var bpm
var song_path
var song_name
var sheet
var index = [0,0]

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
