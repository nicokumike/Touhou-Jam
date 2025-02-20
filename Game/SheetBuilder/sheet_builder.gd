extends Control
class_name SheetBuilder

@export_file("*.json") var music_sheet = "res://Game/Lib/Composer/Music_Sheets/debugsheet.json"
@onready var measure_node = preload("res://Game/SheetBuilder/measure.tscn")

@onready var name_label = $VBoxContainer3/NameLabel
@onready var bpm_label = $VBoxContainer3/BPMLabel
@onready var song_path_label = $VBoxContainer3/SongPathLabel 

@onready var sheet_container = $ScrollContainer/MeasureVContainer
@onready var new_measure_button = $ScrollContainer/MeasureVContainer/NewMeasureButton

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
	song_path_label.text = song_path

	song_name = sheet_data.name
	name_label.text = song_name
		
	bpm = sheet_data.bpm
	bpm_label.text = str("BPM: ", bpm)
	
	sheet = sheet_data.sheet
	prints(bpm, song_path, music, song_name, sheet)
	print('------------------')
	populate_measures(sheet)

func populate_measures(sheet):
	print(sheet)
	for measure in sheet:
		var new_measure: Measure = measure_node.instantiate()
		sheet_container.add_child(new_measure)
		sheet_container.move_child(new_measure, -1)
		new_measure.count.text = str(index[0] + 1)
		
		index[0] += 1
		print(measure)
	sheet_container.move_child(new_measure_button, index[0] + 1)
	pass

func _on_play_song_button_pressed() -> void:
	AudMan.play_music(music)
	pass # Replace with function body.

func _on_stop_button_pressed() -> void:
	#TODO stop music
	pass # Replace with function body.

func _on_test_button_pressed() -> void:
	#TODO go to a debug stage and play this track
	pass # Replace with function body.

func _on_save_button_pressed() -> void:
	#TODO Save the file
	pass # Replace with function body.

func _on_load_button_pressed() -> void:
	#TODO Load the file
	pass # Replace with function body.

func _on_edit_button_pressed() -> void:
	#TODO Bring up a panel that will let you edit the track properties like bpm and name
	pass # Replace with function body.

func _on_new_sheet_button_pressed() -> void:
	#TODO New sheet
	pass # Replace with function body.

func _on_new_measure_button_pressed() -> void:
	#TODO Spawn new measure
	pass # Replace with function body.
