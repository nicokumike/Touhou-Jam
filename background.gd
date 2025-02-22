extends Node2D

var speed = 300
@export var bpm = 148

var music: AudioStreamMP3

@onready var note = preload("res://Scenes/note.tscn")
@onready var spawnPoint = $"../SpawnPoint"
@onready var pointer = $"../Pointer"
@onready var timer = $"../Timer"
@export var song = preload("res://Assets/SFX/penis music.mp3")
@onready var composer = $Composer

@export var boss = preload("res://Scenes/boss.tscn")
@onready var bossSpawnPoint = $"../BossSpawn"

func _ready():
	AudMan.play_music(song, -10)
	composer.initialize()
	timer.wait_time = (60.0/bpm)/4

func _process(delta):
	position.x -= speed * delta

func _on_timer_timeout():
	composer.play_note()
	#var note_instance = note.instantiate()
	#note_instance.setColor(randi_range(1, 4))
	#note_instance.setSpeed(speed)
	#note_instance.position = spawnPoint.position
	#get_parent().add_child(note_instance)

func emit_note(note_data):
	var note_instance = note.instantiate()
	note_instance.position = spawnPoint.position
	note_instance.pointer = pointer.position
	note_instance.hold = note_data.hold
	note_instance.holdTime = note_data.length
	note_instance.speed = speed
	get_parent().add_child(note_instance)
	match note_data.color:
		"Red": note_instance.setColor(4)
		"Blue": note_instance.setColor(2)
		"Green": note_instance.setColor(3)
		"Yellow": note_instance.setColor(1)
	
	pass

func transition():
	timer.stop()
	var boss_instance = boss.instantiate()
	boss_instance.initiate(spawnPoint.position)
	boss_instance.position = bossSpawnPoint.position
	get_parent().add_child(boss_instance)
