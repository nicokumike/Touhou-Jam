extends Control

@export var sample_sfx: AudioStreamMP3
@export var sample_voice: AudioStreamMP3

@onready var master_volume_slider = %MasterSlider
@onready var music_volume_slider  = %MusicSlider
@onready var voice_volume_slider  = %VoiceSlider
@onready var sfx_volume_slider    = %SFXSlider

var music_bus_name: String        = "Music"
var voice_bus_name: String        = "Voice"
var sfx_bus_name: String          = "SFX"
var master_bus_name: String       = "Master"

var master_bus: int
var music_bus: int
var voice_bus: int
var sfx_bus: int

#func _on_option_button_item_selected(index):
	#if index == 0:
		#DisplayServer.window_set_size(Vector2i(2560, 1440))
	#elif index == 1:
		#DisplayServer.window_set_size(Vector2i(1920, 1080))
	#elif index == 2:
		#DisplayServer.window_set_size(Vector2i(1440, 900))
	#elif index == 3:
		#DisplayServer.window_set_size(Vector2i(1366, 768))
	#elif index == 4:
		#DisplayServer.window_set_size(Vector2i(1280, 720))

func _ready():
	master_bus = AudioServer.get_bus_index(master_bus_name)
	music_bus  = AudioServer.get_bus_index(music_bus_name)
	voice_bus  = AudioServer.get_bus_index(voice_bus_name)
	sfx_bus    = AudioServer.get_bus_index(sfx_bus_name)
	master_volume_slider.value = db_to_linear(AudioServer.get_bus_volume_db(master_bus))
	music_volume_slider.value = db_to_linear(AudioServer.get_bus_volume_db(music_bus))
	voice_volume_slider.value = db_to_linear(AudioServer.get_bus_volume_db(voice_bus))
	sfx_volume_slider.value = db_to_linear(AudioServer.get_bus_volume_db(sfx_bus))

func _on_back_button_pressed() -> void:
	SignalBus.game_state_changed.emit("Main")
	queue_free()

func _on_master_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(master_bus, linear_to_db(value))

func _on_master_slider_drag_ended(value_changed: bool) -> void:
	pass # Replace with function body.

func _on_music_slider_value_changed(value):
	AudioServer.set_bus_volume_db(music_bus, linear_to_db(value))

func _on_music_slider_drag_ended(value_changed):
	pass # Replace with function body.

func _on_voice_slider_value_changed(value):
	AudioServer.set_bus_volume_db(voice_bus, linear_to_db(value))

func _on_voice_slider_drag_ended(value_changed):
	AudMan.play_quip(sample_voice)

func _on_sfx_slider_value_changed(value):
	AudioServer.set_bus_volume_db(sfx_bus, linear_to_db(value))

func _on_sfx_slider_drag_ended(value_changed):
	AudMan.play_sfx(sample_sfx)
