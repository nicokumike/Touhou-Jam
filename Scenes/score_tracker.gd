extends Control
@onready var score_count: Label = $HBoxContainer/VBoxContainer2/ScoreCount
@onready var perfect_count: Label = $HBoxContainer/VBoxContainer2/PerfectCount
@onready var great_count: Label = $HBoxContainer/VBoxContainer2/GreatCount
@onready var good_count: Label = $HBoxContainer/VBoxContainer2/GoodCount
@onready var bad_count: Label = $HBoxContainer/VBoxContainer2/BadCount
@onready var miss_count: Label = $HBoxContainer/VBoxContainer2/MissCount
@onready var acccuracy_count: Label = $HBoxContainer/VBoxContainer2/AcccuracyCount

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
