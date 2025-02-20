extends Control
class_name SheetBuilder

@export_file("*.json") var music_sheet = "res://Game/Lib/Composer/Music_Sheets/debugsheet.json"

var music

var bpm
var song_path
var song_name
var sheet = []
var index = [0,0,0]

#This could be made into a global data type
var legend = {
	"R" = "Red",
	"G" = "Green",
	"B" = "Blue",
	"Y" = "Yellow",
	"H" = "Hold",
	"P" = "Projectile",
	"F" = "Fairy",
}

func _ready() -> void:
	initialize()

func initialize():
	var json_as_text = FileAccess.get_file_as_string(music_sheet)
	var sheet_data = JSON.parse_string(json_as_text)
	song_path = sheet_data.song
	music = load(song_path)
	bpm = sheet_data.bpm
	sheet = sheet_data.sheet
	print(sheet_data)

func _on_play_song_button_pressed() -> void:
	AudMan.play_music(music)
	pass # Replace with function body.

func _on_stop_button_pressed() -> void:
	#TODO stop music
	pass # Replace with function body.
