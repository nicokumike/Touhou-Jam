extends Node2D

var speed = 1000
var bpm = 170

@onready var note = preload("res://Scenes/note.tscn")
@onready var spawnPoint = $"../SpawnPoint"
@onready var timer = $"../Timer"
@onready var penisMusic = preload("res://Assets/SFX/penis music.mp3")

func _ready():
	#AudMan.play_music(penisMusic, -20)
	timer.wait_time = 60.0/bpm

func _process(delta):
	position.x -= speed * delta
	pass

func _on_timer_timeout():
	var note_instance = note.instantiate()
	note_instance.setColor(randi_range(1, 4))
	note_instance.setSpeed(speed)
	note_instance.position = spawnPoint.position
	get_parent().add_child(note_instance)
