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

# Song that will play
@export var song = preload("res://Assets/SFX/penis music.mp3")

# Loads music cheat
@onready var composer = $Composer

# Boss scene
@export var boss = preload("res://Scenes/boss.tscn")

# Boss spawn point
@onready var bossSpawnPoint = $"../BossSpawn"

var boss_instance : Node = null 
var music_player = null
var time_begin: float
var time_delay: float
var beat_played = true
var last_beat = 0

func _ready():
	var bgd = backgroundArt.instantiate()
	add_child(bgd)
	time_begin = Time.get_ticks_usec()
	time_delay = AudioServer.get_time_to_next_mix() + AudioServer.get_output_latency()
	
func _process(delta):
	if music_player != null:
		var time := 0.0
			# Obtain from ticks.
		time = (Time.get_ticks_usec() - time_begin) / 1000000.0
		# Compensate.
		time -= time_delay
		
		var beat := int(time * composer.bpm / (60.0 / 4))
		if last_beat != beat:
			composer.play_note()
		last_beat = beat
	
func _unhandled_input(event):
	if event is InputEventKey and !started:
		composer.initialize()
		music_player = AudMan.play_music(song, -10)
		started = true
		$"../AnyKey".visible = false

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
	# Stopping notes
	music_player = null
	if boss_instance == null:
		# Play looping song section
		song = load("res://Game/Lib/Composer/Music_Sheets/Prismriver_Sisters_LOOP.mp3")
		AudMan.play_music(song, -10)
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
		SignalBus.dialogue_finished.connect(_on_dialogue_finished)
	
	# Boss is in the scene
	elif boss_instance.is_inside_tree():
		# Now emit dialogue
		if boss_instance.health <= 0:
			var json_data3 : JSON = preload("res://json_test_3.json")
			SignalBus.dialogue_triggered.emit(json_data3.data)
		else:
			SignalBus.dialogue_triggered.emit(json_data2.data)
			
	#Dialogue
	#----
	#After dialogue is done
	#composer.music_sheet("boss section")
	#composer.initialize()
	
func _on_dialogue_finished():
	song = load("res://Game/Lib/Composer/Music_Sheets/Prismriver_Sisters_BOSS.mp3")
	composer.initialize()
	music_player = AudMan.play_music(song, -10)
	print(music_player)
