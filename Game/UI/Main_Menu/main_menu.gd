extends Control

@onready var menu_music = preload("res://Assets/SFX/BP_Default_Sounds/Default_Muzak.mp3")

func _ready() -> void:
	SignalBus.dialogue_finished.connect(_resume_cutscene)
	#AudMan.play_music(menu_music)
	pass
	
func animate_button(button_node: Node, state: String) -> void:
	pivot_offset = button_node.size / 2
	var tween = create_tween()
	tween.tween_property(button_node, "scale", Vector2(10, 0), 0.05)
	await tween.finished
	SignalBus.game_state_changed.emit(state)
	queue_free()

# Dialogue for the cutscene
var cutscene_dialogue : JSON = preload("res://Game/UI/Main_Menu/Dialogue/level0_1.dialogue.json")

# Function to trigger dialogue then pause
func _trigger_dialogue() -> void:
	# For testing
	# TODO: Would probably be better to pause all other scenes
	$AnimationPlayer.pause()
	SignalBus.dialogue_triggered.emit(cutscene_dialogue.data)
	
	
# Function to resume custcene when dialogue is paused
func _resume_cutscene() -> void:
	$AnimationPlayer.play()

func _on_start_pressed() -> void:
	var tween = create_tween()
	tween.tween_property($VBoxContainer/Start, "scale", Vector2(10, 0), 0.05)
	tween.tween_property($VBoxContainer, "modulate", Color.TRANSPARENT, 0.2)
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property($BlackHouse/Title, "global_position", $end.global_position, 0.3)
	await tween.finished
	await get_tree().create_timer(1.5).timeout
	tween.tween_property($BlackHouse/GPUParticles2D, "modulate", Color.TRANSPARENT, 0.2)
	$AnimationPlayer.play("cutscene")
	

func _on_settings_pressed() -> void:
	await animate_button($VBoxContainer/Settings, "Settings")

func _on_credits_pressed() -> void:
	await animate_button($VBoxContainer/Credits, "Credits")

func _on_quit_pressed() -> void:
	await animate_button($VBoxContainer/Quit, "Quit")

func _on_music_room_pressed() -> void:
	# TODO: Replace with the actual functionality for the music room.
	await animate_button($VBoxContainer/MusicRoom, "MusicRoom")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "cutscene":
		$AnimationPlayer.play("cutscene2")
		#SignalBus.game_state_changed.emit("Start")
		#queue_free()
