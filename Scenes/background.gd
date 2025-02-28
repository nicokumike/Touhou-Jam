extends Node2D

var speed = 300
@export var bpm = 148

var music: AudioStreamMP3

# Background art
@export var backgroundArt =  preload("res://Scenes/background_forest.tscn")

# Level started
var started = false

# Level ended
var ended = false

# Scene for the notes
@onready var note = preload("res://Scenes/note.tscn")

# I assuming this is where projectiles will spawn
@onready var spawnPoint = $"../SpawnPoint"

# Where the notes are going to
@onready var pointer = $"../Pointer"

# Song that will play
@export var song = preload("res://Assets/SFX/penis music.mp3")
@export var loopSong = preload("res://Assets/SFX/penis music.mp3")
@export var bossSong = preload("res://Assets/SFX/penis music.mp3")
@export var winSong = preload("res://Game/Lib/Composer/Music_Sheets/Victory_FIRST.mp3")
@export var winSongLoop = preload("res://Game/Lib/Composer/Music_Sheets/Victory_LOOP.mp3")

# Boss scene
@export var boss = preload("res://Scenes/prismriversisters.tscn")

@export var fairies = [preload("res://Game/Characters/Fairy/fairy_river.tscn"), "GHOST"]

@export_group("Sheets")
#@export_file("*.json") var music_sheet = "res://Game/Lib/Composer/Music_Sheets/debugsheet.json"
@export_file("*.json") var hard_sheet = "res://Game/Lib/Composer/Music_Sheets/debugsheet.json"
@export_file("*.json") var easy_sheet = "res://Game/Lib/Composer/Music_Sheets/debugsheet.json"
@export_file("*.json") var hard_boss_sheet = "res://Game/Lib/Composer/Music_Sheets/debugsheet.json"
@export_file("*.json") var easy_boss_sheet = "res://Game/Lib/Composer/Music_Sheets/debugsheet.json"

@export_group("Dialogue")
@export var boss_dialogue = preload("res://Game/Levels/level1/Dialogue/level1_1.dialogue.json")
@export var win_dialogue = preload("res://Game/Levels/level1/Dialogue/level1_1.dialogue.json")

# Loads music cheat
@onready var composer = $Composer

# Boss spawn point
@onready var bossSpawnPoint = $"../BossSpawn"

var end_score_board = preload("res://Scenes/ScoreTracker.tscn")
var end_score_board_instance : Node = null
var boss_started_talking : bool = false

var boss_instance : Node = null 
var music_player = null
var time_begin: float
var time_delay: float
var beat_played = true
var last_beat = 0

var now = false

func _ready():
	var bgd = backgroundArt.instantiate()
	add_child(bgd)
	time_begin = Time.get_ticks_usec()
	time_delay = AudioServer.get_time_to_next_mix() + AudioServer.get_output_latency()
	SignalBus.transition_finished.connect(trans_finished.bind())
	SignalBus.dialogue_finished.connect(_on_dialogue_finished)
	
	#Start all relevant variables
	boss_instance = null 
	music_player = null
	beat_played = true
	last_beat = 0

	now = false
	started = false
	pointer.cutscene = true

func trans_finished(type_name):
	if type_name == "fade_out":
		SignalBus.finish_transition.emit()
		SignalBus.game_state_changed.emit("Start")
	else:
		pass
	print(type_name)

func level_two():
	SignalBus.transition_start.emit()

func _process(delta):
	if Input.is_action_just_pressed("9"):
		level_two()
		pass
	if Input.is_action_just_pressed("8"):
		$"../Timer2".stop()
		transition()
		#SignalBus.dialogue_finished.connect(_on_dialogue_finished)
		#SignalBus.dialogue_finished.emit()
	#if music_player != null:
	if now:
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
	if event is InputEventKey:
		if !started:
			if SignalBus.difficulty == "Easy":
				composer.music_sheet = easy_sheet
			elif SignalBus.difficulty == "Hard":
				composer.music_sheet = hard_sheet
			#composer.music_sheet = hard_sheet
			composer.initialize()
			AudMan.stop_music()
			#music_player = AudMan.play_music(song, -10)
			$"../Timer2".start()
			now = true
			started = true
			pointer.cutscene = false
			$"../AnyKey".visible = false
			return
		if ended:
			ended = false
			AudMan.stop_music()
			level_two()
			return

# Emits note for the level
func emit_note(note_data):
	var note_instance = note.instantiate()
	note_instance.position = spawnPoint.position
	note_instance.pointer = pointer.position
	note_instance.hold = note_data.hold
	note_instance.holdTime = note_data.length
	note_instance.speed = speed
	note_instance.bpm = bpm
	if note_data.type:
		note_instance.is_fairy = true
		var new_fairy = fairies.pick_random()
		note_instance.spawn_fairy(new_fairy)
	get_parent().add_child(note_instance)
	match note_data.color:
		"Red": note_instance.setColor(4)
		"Blue": note_instance.setColor(2)
		"Green": note_instance.setColor(3)
		"Yellow": note_instance.setColor(1)
		
# Boss transition/spawning
func transition():
	#Is boss?
	#Yes, trigger dialogue
	#No, do this:
	# Stopping notes
	music_player = null
	now = false
	pointer.cutscene = true
	if boss_instance == null:
		# Play looping song section
		music_player = AudMan.play_music(loopSong, -10, true, false)
		# Spawn boss and instantiate it
		boss_instance = boss.instantiate()
		# Setting bosses projectile spawn point
		boss_instance.initiate(spawnPoint.position)
		# Set its position
		boss_instance.position = bossSpawnPoint.position
		# Add scene to tree
		get_parent().add_child(boss_instance)
		
		# Maybe emit when boss is on screen?
		SignalBus.dialogue_triggered.emit(boss_dialogue.data)

	
	# Boss is in the scene
	elif boss_instance.is_inside_tree():
		boss_started_talking = true
		# Now emit dialogue
		#if boss_instance.health <= 0:
			##print("test2")
		SignalBus.dialogue_triggered.emit(win_dialogue.data)
		#level_two()
		#else:
		#SignalBus.dialogue_triggered.emit(json_data2.data)
		
	#Dialogue
	#----
	#After dialogue is done
	#composer.music_sheet("boss section")
	#composer.initialize()
	
func _on_dialogue_finished():
	if boss_started_talking:
		#print("SCENE STARTED")
		music_player = AudMan.play_music(winSong, -10, false)
		music_player.finished.connect(_on_win_music_ended)
		ended = true
		%ComboContainer.visible = false
		$"../HBoxContainer".visible = false
		end_score_board_instance = end_score_board.instantiate()
		add_sibling(end_score_board_instance)
		end_score_board_instance.score_count.text = str(int(pointer.score))
		end_score_board_instance.perfect_count.text = str(pointer.hit_modifier["perfect"])
		end_score_board_instance.great_count.text = str(pointer.hit_modifier["great"])
		end_score_board_instance.good_count.text = str(pointer.hit_modifier["good"])
		end_score_board_instance.bad_count.text = str(pointer.hit_modifier["bad"])
		end_score_board_instance.miss_count.text = str(pointer.hit_modifier["misses"])
		
		# Calculate accuracy by comparing hits to total notes
		var total_hits : int = (pointer.hit_modifier["perfect"] + 
				pointer.hit_modifier["great"] + 
				pointer.hit_modifier["good"] + 
				pointer.hit_modifier["bad"])
		var total_notes : int = total_hits + pointer.hit_modifier["misses"]
			
		end_score_board_instance.acccuracy_count.text = "%.2f" % ((total_hits / float(total_notes)) * 100.0)

		#on_win_music_ended()
	else:
		#AudMan.stop_music()
		song = bossSong
		if SignalBus.difficulty == "Easy":
			composer.music_sheet = easy_boss_sheet
		elif SignalBus.difficulty == "Hard":
			composer.music_sheet = hard_boss_sheet
		#composer.music_sheet = easy_boss_sheet
		composer.initialize()
		
		#Wait for loop to finish
		var waitTime = music_player.stream.get_length() - music_player.get_playback_position()
		$"../Timer2".wait_time += waitTime
		$"../Timer2".start()
		$"../Timer".wait_time = waitTime
		$"../Timer".start()

func _on_timer_2_timeout():
	music_player = AudMan.play_music(song, -10, false, false)
	pass # Replace with function body.

func _on_win_music_ended():
	music_player.finished.disconnect(_on_win_music_ended)
	music_player = AudMan.play_music(winSongLoop, -10, true, false)

func _on_timer_timeout():
	now = true
	pointer.cutscene = false
