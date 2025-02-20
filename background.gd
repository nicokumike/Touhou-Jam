extends Node2D

var speed = 300
@export var bpm = 170

var music: AudioStreamMP3

var noteCount = 0
var bossCount = 20

@onready var note = preload("res://Scenes/note.tscn")
@onready var spawnPoint = $"../SpawnPoint"
@onready var timer = $"../Timer"
@export var penisMusic = preload("res://Assets/SFX/penis music.mp3")
@onready var composer = $Composer

func _ready():
	AudMan.play_music(penisMusic, -20)
	composer.initialize()
	timer.wait_time = (60.0/bpm)/4
	

func _process(delta):
	position.x -= speed * delta
	#if noteCount >= bossCount:
		#timer.stop()

func _on_timer_timeout():
	composer.play_note()
	#var note_instance = note.instantiate()
	#note_instance.setColor(randi_range(1, 4))
	#note_instance.setSpeed(speed)
	#note_instance.position = spawnPoint.position
	#get_parent().add_child(note_instance)	
	noteCount += 1

func emit_note(note_data):
	var note_instance = note.instantiate()
	match note_data.color:
		"Red": note_instance.setColor(4)
		"Blue": note_instance.setColor(2)
		"Green": note_instance.setColor(3)
		"Yellow": note_instance.setColor(1)
	note_instance.setSpeed(speed)
	note_instance.position = spawnPoint.position
	get_parent().add_child(note_instance)
	pass
