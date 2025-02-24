extends Control
class_name SheetBuilder

@export_file("*.json") var music_sheet = "res://Game/Lib/Composer/Music_Sheets/debugsheet.json"
@onready var measure_node = preload("res://Game/SheetBuilder/measure.tscn")
@onready var edit_panel = preload("res://Game/SheetBuilder/edit_panel.tscn")

@onready var name_label: Label = $VBoxContainer3/NameLabel
@onready var bpm_label: Label = $VBoxContainer3/BPMLabel
@onready var song_path_label: Label = $VBoxContainer3/SongPathLabel 

@onready var scroll_container: ScrollContainer = $ScrollContainer
@onready var sheet_container: VBoxContainer = $ScrollContainer/MeasureVContainer
@onready var new_measure_button: Button = $ScrollContainer/MeasureVContainer/NewMeasureButton
@onready var m_timer: Timer = $MeasureTimer
@onready var music_player: AudioStreamPlayer = $MusicPlayer

var music
var bpm
var song_path
var song_name
var sheet = []
var index = [0,0,0]
var current_measure = 1

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
	m_timer.wait_time = (60 / bpm) * 4
	#prints(m_timer.wait_time, bpm)
	var music = load(song_path)
	music_player.stream = music
	
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
		new_measure.play_from_measure.connect(on_play_from_measure.bind())
		
		index[0] += 1
		#print(measure)
	sheet_container.move_child(new_measure_button, index[0] + 1)

func on_play_from_measure(measure):
	var measures_collection = $ScrollContainer/MeasureVContainer.get_children()
	var measure_time = ((60 / bpm) * 4) * measure
	music_player.play(float(measure_time))
	current_measure = measure + 1
	m_timer.start()
	for count in measure + 1:
		var to_highlight = measures_collection[count]
		print(measures_collection[count])
		to_highlight.modulate = Color.AQUA
	

	#var measures = $ScrollContainer/MeasureVContainer.get_children()
	##prints(current_measure, measures, measures[current_measure -1])
	#var new_measure = measures[current_measure]
	##print(new_measure)
	#if new_measure:
		#new_measure.modulate = Color.AQUA
	#current_measure += 1
	#if current_measure == measures.size():
		#m_timer.stop()
		#current_measure = 1

func on_new_note(data):
	#print("TOP LEVEL",data)
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
	#AudMan.play_music(music)
	music_player.play(0)
	m_timer.start()
	var measures = $ScrollContainer/MeasureVContainer.get_children()
	#prints(current_measure, measures, measures[current_measure -1])
	var new_measure = measures[0]
	if new_measure:
		new_measure.modulate = Color.AQUA

func _on_stop_button_pressed() -> void:
	#AudMan.stop_music()
	music_player.stop()
	m_timer.stop()
	m_timer.wait_time = (60 / bpm) * 4
	var measures = $ScrollContainer/MeasureVContainer.get_children()
	current_measure = 1
	for measure in measures:
		measure.modulate = Color.WHITE

func _on_test_button_pressed() -> void:
	#TODO go to a debug stage and play this track
	pass # Replace with function body.

func _on_save_button_pressed() -> void:
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
	#TODO File picker
	var editor: EditorPanel = edit_panel.instantiate()
	add_child(editor)
	editor.bpm.text = str(bpm)
	editor.sheet_name.text = song_name
	editor.path.text = song_path
	editor.confirm_edit.connect(on_edited_sheet.bind())

func on_edited_sheet(data):
	song_path = data.path
	song_path_label.text = song_path
	
	song_name = data.name
	name_label.text = song_name
	
	bpm = data.bpm
	bpm_label.text = str("BPM: ", bpm)

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


func _on_measure_timer_timeout():
	var measures = $ScrollContainer/MeasureVContainer.get_children()
	#prints(current_measure, measures, measures[current_measure -1])
	var new_measure = measures[current_measure]
	#print(new_measure)
	if new_measure:
		new_measure.modulate = Color.AQUA
	current_measure += 1
	if current_measure == measures.size():
		m_timer.stop()
		current_measure = 1
