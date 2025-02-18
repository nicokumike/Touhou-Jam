class_name EntityState extends State

@onready var animation_handler: AnimationHandler_Spine = (func get_animation_handler() -> AnimationHandler_Spine:
	var current = self
	while current != null:
		if current is Entity and current.animation_handler:
			return current.animation_handler
		current = current.get_parent()
	return null
).call()

@export var animation_spine: SpineAnimationAsset

var entity: Entity

func _ready() -> void:
	await owner.ready
	entity = owner as Entity
	assert(entity, "The EntityState must only be used by an Entity node.")

func enter(_previous_state_path: String, _data := {}) -> void:
	animation_handler.play_animation(animation_spine.animation_name, animation_spine.loop, 0, animation_spine.mix_duration)
