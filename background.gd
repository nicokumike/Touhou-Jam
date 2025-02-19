extends Node2D

var speed = 300
@export var bpm = 170

var noteCount = 0
var bossCount = 20

@onready var note = preload("res://Scenes/note.tscn")
@onready var spawnPoint = $"../SpawnPoint"
@onready var timer = $"../Timer"
@onready var penisMusic = preload("res://Assets/SFX/penis music.mp3")
@onready var composer = $Composer

func _ready():
	#AudMan.play_music(penisMusic, -20)
	composer.initialize()
	timer.wait_time = 60.0/bpm
	

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
