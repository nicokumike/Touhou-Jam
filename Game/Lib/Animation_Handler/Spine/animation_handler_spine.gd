class_name AnimationHandler_Spine extends SpineSprite

@export var skinName: String
@export var initial_animation: SpineAnimationAsset

func _ready():
	if not skinName.is_empty():
		get_skeleton().set_skin_by_name(skinName)
	if initial_animation:
		play_animation_asset(initial_animation)

## Plays the specified animation on the given track.
## 
## @param animation_name: The name of the animation to play.
## @param loop: Whether the animation should loop.
## @param track: The track index to play the animation on. Defaults to 0.
## @param mix_duration: The duration of the mix between animations. Defaults to -1, which uses the default mix duration from the Skeleton Data Resource file.
## @param speed: The time scale of the animation. Defaults to 1.
## @return: The track entry for the animation.
func play_animation(animation_name: String, loop: bool, track: int = 0, mix_duration: float = -1, speed: float = 1) -> SpineTrackEntry:
	var track_entry = get_animation_state().set_animation(animation_name, loop, track)
	track_entry.set_time_scale(speed)
	if mix_duration >= 0:
		track_entry.set_mix_duration(mix_duration)
	return track_entry

## Plays the specified animation from the provided Spine Animation Asset.
##
## @param animation_asset: The Spine Animation Asset.
## @return: The track entry for the animation.
func play_animation_asset(animation_asset: SpineAnimationAsset) -> SpineTrackEntry:
	return play_animation(
		animation_asset.animation_name,
		animation_asset.loop,
		animation_asset.track,
		animation_asset.mix_duration,
		animation_asset.speed)
