extends Control

@onready var menu_music = preload("res://Assets/SFX/BP_Default_Sounds/Default_Muzak.mp3")

func _ready():
	AudMan.play_music(menu_music)

func _on_start_pressed():
	SignalBus.game_state_changed.emit("Start")
	queue_free()

func _on_settings_pressed():
	SignalBus.game_state_changed.emit("Settings")
	queue_free()

func _on_credits_pressed():
	SignalBus.game_state_changed.emit("Credits")
	queue_free()

func _on_quit_pressed():
	SignalBus.game_state_changed.emit("Quit")
