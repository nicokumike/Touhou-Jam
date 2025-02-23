extends Node2D

var speed = 300
@export var bpm = 148

var music: AudioStreamMP3

# Background art
@onready var backgroundArt = preload("res://Scenes/background_forest.tscn")
# Level started
var started = false

# Scene for the notes
@onready var note = preload("res://Scenes/note.tscn")

# I assuming this is where projectiles will spawn
@onready var spawnPoint = $"../SpawnPoint"

# Where the notes are going to
@onready var pointer = $"../Pointer"

# Time between 16ths
@onready var timer = $"../Timer"

# Song that will play
@export var song = preload("res://Assets/SFX/penis music.mp3")

# Loads music cheat
@onready var composer = $Composer

# Boss scene
@export var boss = preload("res://Scenes/boss.tscn")

# Boss spawn point
@onready var bossSpawnPoint = $"../BossSpawn"

var boss_instance : Node = null 

func _ready():
	var bgd = backgroundArt.instantiate()
	add_child(bgd)

func _unhandled_input(event):
	if event is InputEventKey and !started:
		composer.initialize()
		timer.wait_time = (60.0/bpm)/4
		timer.start()
		AudMan.play_music(song, -10)
		started = true
		$"../AnyKey".visible = false

func _on_timer_timeout():
	composer.play_note()
	#var note_instance = note.instantiate()
	#note_instance.setColor(randi_range(1, 4))
	#note_instance.setSpeed(speed)
	#note_instance.position = spawnPoint.position
	#get_parent().add_child(note_instance)

# Emits note for the level
func emit_note(note_data):
	var note_instance = note.instantiate()
	note_instance.position = spawnPoint.position
	note_instance.pointer = pointer.position
	note_instance.hold = note_data.hold
	note_instance.holdTime = note_data.length
	note_instance.speed = speed
	note_instance.bpm = bpm
	get_parent().add_child(note_instance)
	match note_data.color:
		"Red": note_instance.setColor(4)
		"Blue": note_instance.setColor(2)
		"Green": note_instance.setColor(3)
		"Yellow": note_instance.setColor(1)


var json_data : JSON = preload("res://json_test_.json")
var json_data2 : JSON = preload("res://json_test_2.json")
# Boss transition/spawning
func transition():
	#Is boss?
	#Yes, trigger dialogue
	#No, do this:
	# Stopping timer
	print("Spawn boss")
	if boss_instance == null:
		timer.stop()
		# Spawn boss and instantiate it
		boss_instance = boss.instantiate()
		# Setting bosses projectile spawn point
		boss_instance.initiate(spawnPoint.position)
		# Set its position
		boss_instance.position = bossSpawnPoint.position
		# Add scene to tree
		get_parent().add_child(boss_instance)
		
		# Maybe emit when boss is on screen?
		SignalBus.dialogue_triggered.emit(json_data.data)
	
	# Boss is in the scene
	elif boss_instance.is_inside_tree():
		# Now emit dialogue
		SignalBus.dialogue_triggered.emit(json_data2.data)
	
	#Dialogue
	#----
	#After dialogue is done
	#composer.music_sheet("boss section")
	#composer.initialize()
	
