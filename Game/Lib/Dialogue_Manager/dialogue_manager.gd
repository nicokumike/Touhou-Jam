extends CanvasLayer

# TODO: Add audio sounds for character text, cause its kinda cool no?
# TODO: Darken the dialogue not being played

# Export enum for speed
@export_enum("Slow", "Medium", "Fast") var text_speed : int = 0

const text_speed_dict : Dictionary = {
	0 : .65,   # Slow
	1 : 1,    # Medium
	2 : 2.5   # Fast
}

## Path template for character data resources
const CHARACTER_DATA_PATH: String = "res://Game/Lib/Resources/%s.tres"

## Cached character resources to prevent redundant loading
var loaded_characters: Dictionary = {}

## Stores the processed dialogue entries
var dialogue_sequence: Array = []

## Reference to the active dialogue box
var current_dialogue_box: RichTextLabel = null

# Load this up in onready
var dialogue_dictionary : Dictionary = {}

## Dialogue control flags
var is_text_revealing: bool = false

## Index of the currently displayed dialogue entry
var dialogue_index: int = 0
var max_dialogue_index: int = 0

#region Signal Connections
# Called when the node enters the scene tree for the first time.
func _ready():
	# Connect to the dialogue signals
	SignalBus.dialogue_triggered.connect(_on_dialogue_triggered)
	SignalBus.dialogue_finished.connect(_on_dialogue_finished)
	dialogue_dictionary["Top"] = %TopDialogue
	dialogue_dictionary["Bottom"] = %BottomDialogue
	current_dialogue_box = %BottomDialogue
#endregion
	
#region Main functions
func _shortcut_input(event: InputEvent) -> void:
	# Check if the skip or continue button is pressed
	if event.is_action_pressed(&"skip") or event.is_action_pressed(&"cont"):
		# If an animation is playing, seek to the end
		if %DialogueAnimationPlayer.is_playing():
			# Grab current animation
			var current_anim : String = %DialogueAnimationPlayer.current_animation
			
			# Don't skip the fade in
			if current_anim != "Fade_In":
				# Get length of the current animation
				var anim_length : float = %DialogueAnimationPlayer.get_animation(current_anim).length
				# Seek to the end and force an update
				%DialogueAnimationPlayer.seek(anim_length, true)
			
		# Otherwise, move to the next dialogue entry
		else:
			if is_text_revealing:
				dialogue_index += 1
				progress_dialogue()

	
# Load in the next batch of dialogue
func progress_dialogue() -> void:
	# Make sure we are not at the end of our dialogue
	if dialogue_index != max_dialogue_index:
		# Make sure we are not narrating stuff
		if not dialogue_sequence[dialogue_index]["type"] == "narration":
			# Handle bottom dialogue
			if dialogue_sequence[dialogue_index]["position"] == "Bottom":
				%BottomDialogueCover.visible = false
				if %TopDialogueCont.visible:
					%TopDialogueCover.visible = true
				current_dialogue_box = dialogue_dictionary[dialogue_sequence[dialogue_index]["position"]]
				%BottomTextureRect.texture = dialogue_sequence[dialogue_index]["character_resource"].expression[dialogue_sequence[dialogue_index]["expression"]]
				%BottomSpeaker.text = dialogue_sequence[dialogue_index]["character_name"]
				%BottomDialogue.text = dialogue_sequence[dialogue_index]["text"]
				%DialogueAnimationPlayer.play("reveal_text_bottom")
			# Handle top dialogue
			else:
				%TopDialogueCover.visible = false
				if %BottomDialogueCont.visible:
					%BottomDialogueCover.visible = true
				current_dialogue_box = dialogue_dictionary[dialogue_sequence[dialogue_index]["position"]]
				%TopTextureRect.texture = dialogue_sequence[dialogue_index]["character_resource"].expression[dialogue_sequence[dialogue_index]["expression"]]
				%TopSpeaker.text = dialogue_sequence[dialogue_index]["character_name"]
				%TopDialogue.text = dialogue_sequence[dialogue_index]["text"]
				%DialogueAnimationPlayer.play("reveal_text_top")
		# Handle narration
		else:
			# For now narration will just go in the bottom.
			# Maybe hide top dialogue when narration goes on?
			%TopDialogueCont.visible = false
			%TopDialogueCover.visible = false
			%BottomDialogueCover.visible = false
			
			current_dialogue_box = dialogue_dictionary["Bottom"]
			%BottomTextureRect.texture = null
			%BottomSpeaker.text = ""
			%BottomDialogue.text = dialogue_sequence[dialogue_index]["text"]
			%DialogueAnimationPlayer.play("reveal_text_bottom")
			
	# If we are at the end, set index to 0 and fade out
	else:
		dialogue_index = 0
		SignalBus.dialogue_finished.emit()
	
func _play_typing_sound() -> void:
	# Sound effects later on, maybe player every other tick or whatever
	# Maybe each character has their own unique sound
	pass
	
#endregion
	
#region Signal listeners
# Called when dialogue data is received from SignalBus
# Set current dialogue box here for the start
func _on_dialogue_triggered(dialogue_data: Dictionary) -> void:
	dialogue_index = 0
	
	# Discover all unique characters in the dialogue. Load resources for all required characters
	load_character_resources(discover_characters(dialogue_data))
	
	# Process the dialogue data into a usable sequence
	parse_dialogue_data(dialogue_data)
	
	# To ensure we don't go over the index size
	max_dialogue_index = dialogue_sequence.size()
	
	# Start dialouge process.
	visible = true
	is_text_revealing = true
	
	progress_dialogue()
	
	%DialogueAnimationPlayer.play("Fade_In")
	
func _on_dialogue_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == &"Fade_In":
		# Now start the dialogue stuff here
		%DialogueAnimationPlayer.speed_scale = text_speed_dict[text_speed]
		
		# Make the appropriate objects visible
		if dialogue_sequence[dialogue_index]["position"] == "Bottom":
			%BottomDialogueCont.visible = true
			%DialogueAnimationPlayer.play("reveal_text_bottom")
		else:
			%TopDialogueCont.visible = true
			%DialogueAnimationPlayer.play("reveal_text_top")
			
	elif anim_name == &"Fade_Out":
		%TopDialogue.visible_characters = 0
		%BottomDialogue.visible_characters = 0
	
func _on_dialogue_finished():
	is_text_revealing = false
	# Setting speed scale back to default
	%DialogueAnimationPlayer.speed_scale = text_speed_dict[1]
	%DialogueAnimationPlayer.play("Fade_Out")
#endregion
	
#region Initialization functions for loading in resources and dialogue
# Scan through dialogue to find all unique characters
func discover_characters(dialogue_data: Dictionary) -> Array:
	var unique_characters : Array = []
	
	# Examine each dialogue entry
	for entry in dialogue_data.values():
		# Check if this is a character dialogue (has "Character" field)
		if "Character" in entry:
			var character_name : String = entry["Character"][0]
			# Only add unique character
			if not character_name in unique_characters:
				unique_characters.append(character_name)
	
	return unique_characters

# Load character resources for all required characters
func load_character_resources(character_names: Array) -> void:
	for character_name in character_names:
		# Skip if we've already loaded this character
		if character_name in loaded_characters:
			continue
			
		# Converting character name to lowercase for consistent file naming
		var resource_path : String = CHARACTER_DATA_PATH % character_name.to_lower()
		
		# Attempt to load the character resource
		var character_resource : Resource = load(resource_path)
		if character_resource:
			loaded_characters[character_name] = character_resource
		else:
			# Missing file or something
			push_warning("Failed to load character resource: %s" % resource_path)

# Parse dialogue data into a structured sequence
func parse_dialogue_data(dialogue_data: Dictionary) -> void:
	# Clear previous dialogue
	dialogue_sequence.clear()
	
	# Parse dictionary entries into structured format
	for entry in dialogue_data.values():
		var processed_entry : Dictionary = {}
		
		if "Character" in entry:
			# Character[Name, Expression, Position]
			var character_info : Array = entry["Character"]
			
			processed_entry = {
				"type": "character_dialogue",
				"character_name": character_info[0],
				"expression": character_info[1],
				"position": character_info[2],
				"text": entry["Text"],
				
				# Include the loaded character resource
				"character_resource": loaded_characters.get(character_info[0])
			}
		else:
			# Narration
			processed_entry = {
				"type": "narration",
				"text": entry["Text"]
			}
			
		dialogue_sequence.append(processed_entry)
#endregion
