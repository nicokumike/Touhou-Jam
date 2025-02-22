extends Control
class_name SheetBuilder

@export_file("*.json") var music_sheet = "res://Game/Lib/Composer/Music_Sheets/debugsheet.json"
@onready var measure_node = preload("res://Game/SheetBuilder/measure.tscn")

@onready var name_label: Label = $VBoxContainer3/NameLabel
@onready var bpm_label: Label = $VBoxContainer3/BPMLabel
@onready var song_path_label: Label = $VBoxContainer3/SongPathLabel 

@onready var scroll_container: ScrollContainer = $ScrollContainer
@onready var sheet_container: VBoxContainer = $ScrollContainer/MeasureVContainer
@onready var new_measure_button: Button = $ScrollContainer/MeasureVContainer/NewMeasureButton

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
	#print(sheet)
	for measure in sheet:
		var new_measure: Measure = measure_node.instantiate()
		sheet_container.add_child(new_measure)
		sheet_container.move_child(new_measure, -1)
		new_measure.count = index[0] + 1
		new_measure.count_label.text = str(index[0] + 1)
		new_measure.measure_data = measure
		new_measure.update_measure(measure)
		new_measure.on_changed_note.connect(on_new_note.bind())
		
		index[0] += 1
		#print(measure)
	sheet_container.move_child(new_measure_button, index[0] + 1)

func on_new_note(data):
	print("TOP LEVEL",data)
	var index = [data.index[0] -1, data.index[1] -1, data.index[2] -1]
	#print(index)
	#var note = sheet[index[0]][index[1]][index[2]]
	#print(note)
	#note = data.note_data.text
	#print(note)
	#print(sheet[index[0]][index[1]][index[2]])
	sheet[index[0]][index[1]][index[2]] = data.note_data.text
	#print(sheet[index[0]][index[1]][index[2]])
	#print(sheet)

func save_to_file(content):
	#var save_dir = "res://Game/Lib/Composer/Music_Sheets/"
	#var save_path = str(save_dir, 'new_sheet.json')
	var save_path = music_sheet
	
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_string(content)

func _on_play_song_button_pressed() -> void:
	AudMan.play_music(music)

func _on_stop_button_pressed() -> void:
	AudMan.stop_music()

func _on_test_button_pressed() -> void:
	#TODO go to a debug stage and play this track
	pass # Replace with function body.

func _on_save_button_pressed() -> void:
	#TODO Save the file
	var data = {
		"name": song_name,
		"bpm": bpm,
		"sheet": sheet,
		"song": song_path
	}
	save_to_file(JSON.stringify(data, "\t"))

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
	var new_data = [[1, 2, 3, 4],[1, 2, 3, 4],[1, 2, 3, 4],[1, 2, 3, 4]]
	var new_measure: Measure = measure_node.instantiate()
	sheet.append(new_data)
	sheet_container.add_child(new_measure)
	sheet_container.move_child(new_measure, -1)
	new_measure.count = sheet.size()
	new_measure.count_label.text = str(sheet.size())
	new_measure.measure_data = new_data
	new_measure.on_changed_note.connect(on_new_note.bind())
	#print(new_measure.measure_data)
	sheet_container.move_child(new_measure_button, sheet.size() + 1)
	#This only works by waiting a frame, dunno why
	call_deferred("update_scroll")

func update_scroll():
	scroll_container.set_deferred("scroll_vertical", 999999)
