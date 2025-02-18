extends SpineSprite

class_name AnimationHandler_Spine

@export var initial_animation_name: String

func _ready():
	play_animation(initial_animation_name, true)

## Plays the specified animation on the given track.
## 
## @param animation_name: The name of the animation to play.
## @param loop: Whether the animation should loop.
## @param track: The track index to play the animation on. Defaults to 0.
## @param mix_duration: The duration of the mix between animations. Defaults to -1, which uses the default mix duration from the Skeleton Data Resource file.
## @return: The track entry for the animation.
func play_animation(animation_name: String, loop: bool, track: int = 0, mix_duration: float = -1):
	var track_entry = get_animation_state().set_animation(animation_name, loop, track)
	if mix_duration >= 0:
		track_entry.set_mix_duration(mix_duration)
	return track_entry
