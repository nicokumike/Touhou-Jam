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

func update_measure(data):
	print(data)
	pass

func _ready() -> void:
	for beat in beats:
		hook_up(beat)

func hook_up(beat: HBoxContainer):
	var children = beat.get_children()
	for button: RemapNoteButton in children:
		button.new_note.connect(_on_button_new_note.bind())
	#print(children)

func _on_button_new_note(data):
	#print(data)
	on_changed_note.emit(data)
	#pass
