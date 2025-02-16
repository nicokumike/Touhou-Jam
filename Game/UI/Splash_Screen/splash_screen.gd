extends Control

@onready var drumsfx = preload("res://Assets/SFX/SplashScreen/bp_cadence.mp3")
@onready var bereparedosfx = [
	preload("res://Assets/SFX/SplashScreen/b01.wav"),
	preload("res://Assets/SFX/SplashScreen/b02.wav"),
	preload("res://Assets/SFX/SplashScreen/b03.wav"),
	preload("res://Assets/SFX/SplashScreen/b04.wav"),
	preload("res://Assets/SFX/SplashScreen/b05.wav"),
	preload("res://Assets/SFX/SplashScreen/b06.wav"),
	preload("res://Assets/SFX/SplashScreen/b07.wav"),
	preload("res://Assets/SFX/SplashScreen/b08.wav"),
	preload("res://Assets/SFX/SplashScreen/b09.wav"),
]

func _play_splash_sfx():
	AudMan.play_sfx(drumsfx)

func _play_beretchan_sfx():
	var random = randi_range(0,bereparedosfx.size() - 1)
	AudMan.play_sfx_wav(bereparedosfx[random], 1)
	#var game_man: game_manager = get_tree().get_first_node_in_group('game')
	#game_man.main_menu(true)

func call_menu():
	SignalBus.game_state_changed.emit("Main")

func _on_splash_anim_animation_finished(anim_name):
	if anim_name == 'splash':
		#var game_man: game_manager = get_tree().get_first_node_in_group('game')
		#game_man.main_cutscene()
		#game_man.title.canvas.visible = true
		queue_free()
	pass # Replace with function body.
