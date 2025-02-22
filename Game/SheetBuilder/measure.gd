extends MarginContainer
class_name Measure

var count

@onready var count_label = $HBoxContainer/MeasureCountLabel
@onready var beats = [
	$HBoxContainer/BeatHContainer, 
	$HBoxContainer/BeatHContainer2, 
	$HBoxContainer/BeatHContainer3, 
	$HBoxContainer/BeatHContainer4
]

var measure_data = []

signal on_changed_note
#
func update_measure(data):
	print(data)
	for beat in beats:
		var children = beat.get_children()
		#print(beat)
		for note: RemapNoteButton in children:
			var index = [note.beat -1, note.num -1]
			var preloaded_note = data[index[0]][index[1]]
			#prints(note.beat, note.num, index, preloaded_note)
			note.load_note(preloaded_note)
			
			
		#for note in beat:
			#print(note)
			#pass
	pass

func _ready() -> void:
	for beat in beats:
		hook_up(beat)
		#print(beat)

func hook_up(beat: HBoxContainer):
	var children = beat.get_children()
	for button: RemapNoteButton in children:
		button.new_note.connect(_on_button_new_note.bind())
	#print(children)

func _on_button_new_note(data):
	var new_note = {
		"note_data": data,
		"index": [count, data.index[0], data.index[1]]
	}
	on_changed_note.emit(new_note)
