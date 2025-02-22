extends Control
class_name EditorPanel

signal confirm_edit

@onready var path:       TextEdit = $Panel/VBoxContainer/SongPath
@onready var sheet_name: TextEdit = $Panel/VBoxContainer/SheetName
@onready var bpm:        TextEdit = $Panel/VBoxContainer/BPM

func _on_confirm_button_pressed():
	var data = {
		"path" : path.text,
		"name" : sheet_name.text,
		"bpm" : int(bpm.text)
	}
	confirm_edit.emit(data)
	queue_free()
	pass # Replace with function body.

##TODO change song path to a file picker, it's already there it's just hidden and not connected

func _on_cancel_button_pressed():
	queue_free()
