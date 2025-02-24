extends CharacterBody2D

# For hitting notes and stuff

# Scene
@onready var noteGraphics = preload("res://Game/UI/Notes_Graphics/note_graphics.tscn")

@onready var scoreAmount = $"../HBoxContainer/VBoxContainer2/ScoreAmount"
@onready var comboAmount = $"../HBoxContainer/VBoxContainer2/ComboAmount"

# Scoring
var score = 0
var combo = 0

# Note logic
var note_queue : Array
var note_hit

# Tells us what kind of note we hit
var note_precision = 0

# To keep track of how many perfects we have landed
var perfect_streak : int = 0

# Multipliers
var precisionMult = 1
var comboMult = 1

# Miss and holding
var miss = false
var holding = false

# Keep track of accuracy

# Longest perfect streak
var longest_perfect_streak : int = 0
# Tally up how many good bad perfects etc
var hit_modifier : Dictionary = {
	"misses" : 0,   # Miss
	"bad" : 0,    # Bad
	"good" : 0,   # Good
	"great" : 0,  # Great
	"perfect" : 0 # Perfect
}
# Total score

# Dev's best score 
# Exception when on cutscene
var cutscene = false

func _process(delta):
	$FlandreContactPoint.rotation_degrees += .5
	scoreAmount.text = str(score)
	comboAmount.text = str(combo)
	if holding:
		score += 1 * precisionMult * comboMult

func _unhandled_input(event):
	if event is InputEventKey and !cutscene:
		var hitList = checkNotes()
		var hitNote = hitList[0]
		var hitPrecision = hitList[1]
		var keyPress = checkPress(event)
		var tween = create_tween()
		arrow()
		if keyPress == 1:
			tween.tween_property($ContactPointArrow, "rotation_degrees", 270, 0)
			$ContactPointArrow.modulate = Color.YELLOW
		elif keyPress == 2:
			$ContactPointArrow.modulate = Color.BLUE
			tween.tween_property($ContactPointArrow, "rotation_degrees", 180, 0)
		elif keyPress == 3:
			$ContactPointArrow.modulate = Color.GREEN
			tween.tween_property($ContactPointArrow, "rotation_degrees", 90, 0)
		elif keyPress == 4:
			$ContactPointArrow.modulate = Color.RED
			tween.tween_property($ContactPointArrow, "rotation_degrees", 360, 0)
		if hitNote != null and hitPrecision > 0 and keyPress > 0:
			note_hit = false
			if keyPress == hitNote.type:
				note_hit = true
			if note_hit:
				# match precision: #BAD
				#	1: badcounter ++
				#	2: goodcounter ++
				#	3: greatcounter ++
				
				precisionMult = 1
				comboMult = 1
				combo += 1
				if combo >= 10:
					comboMult = 2
				if combo >= 20:
					comboMult = 3
				if combo >= 30:
					comboMult = 4
				if combo >= 50:
					comboMult = 5
				if combo >= 100:
					comboMult = 7
				match hitPrecision:
					1: precisionMult = 0.5 #Bad
					2: precisionMult = 1 #Good
					3: precisionMult = 3 #Great
					4: precisionMult = 5 #Perfect
				score += 100 * precisionMult * comboMult
				if hitNote.hold:
					holding = true
					hitNote.holdNote()
					hitNote.pointerObj = self
				else:
					hitNote.animPlayer.play("death")
					hitNote.enemyPointArrow.visible = false
					hitNote.dead = true
					hitNote.hit = true
			else:
				miss = true
				combo = 0
		else:
			if keyPress > 0:
				miss = true
				combo = 0
		if holding:
			if keyPress < 0:
				holding = false
				hitNote.queue_free()
			pass
		if keyPress > 0:
			printPrecision()
		
func releaseNote():
	holding = false

func arrow():
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_BOUNCE)
	tween.tween_property($FlandreContactPoint, "scale", Vector2(2.5,1.5), .033)
	tween.tween_property($FlandreContactPoint, "scale", Vector2(1.5,2.5), .033)
	tween.tween_property($FlandreContactPoint, "scale", Vector2(2,2), .033)

func checkNotes() -> Array:
	var retArray = [null, 0]
	var notes = get_tree().get_nodes_in_group("note")
	while notes.size() > 0 and notes[0].dead:
		notes.erase(notes[0])
	
	if notes.size() > 0:
		var closestNote = notes[0]
		var precision = closestNote.checkPosition()
		retArray = [notes[0], notes[0].checkPosition()]
		note_precision = precision
	return retArray
		
func checkPress(event : InputEventKey) -> int:
	if event.is_action_pressed("Yellow"):
		return 1
	if event.is_action_pressed("Blue"):
		return 2
	if event.is_action_pressed("Green"):
		return 3
	if event.is_action_pressed("Red"):
		return 4
	if event.is_action_released("Yellow"):
		return -1
	if event.is_action_released("Blue"):
		return -2
	if event.is_action_released("Green"):
		return -3
	if event.is_action_released("Red"):
		return -4
	return 0

func resetPrecision():
	miss = false
	note_precision = 0


var current_streak : int = 0
func printPrecision():
	if !note_hit:
		note_precision = 0
	var noteLabel = noteGraphics.instantiate()
	add_child(noteLabel)
	var damage : int
	var boss := get_node_or_null("../Boss")
	match noteLabel.initiate(note_precision):
		0:
			hit_modifier["misses"] += 1
			perfect_streak = 0
			current_streak = 0
		1:
			hit_modifier["bad"] += 1
			perfect_streak = 0
			current_streak = 0
		2:
			hit_modifier["good"] += 1
			perfect_streak = 0
			current_streak = 0
			damage = 5
		3:
			hit_modifier["great"] += 1
			perfect_streak = 0
			current_streak = 0
			damage = 10
		4:
			hit_modifier["perfect"] += 1
			# So we loop and you need to land another 4 hits
			perfect_streak = (perfect_streak + 1) % 5
			current_streak += 1
			longest_perfect_streak = max(longest_perfect_streak, current_streak)
			
			damage = 20
	# Boss is in the scene so make it take damage
	if boss != null:
		if perfect_streak == 4:
			# perfect streak gives us an additional 100 damage
			damage = damage + 100
		if boss.has_method("take_damage"):
			boss.take_damage(damage)
			
	noteLabel.global_position = position
	noteLabel.global_position.y -= 250
	
	noteLabel.global_position.y += randf_range(-20, 20)
	noteLabel.global_position.x += randf_range(-20, 20)
	note_hit = false

#func _on_bad_area_exited(area):
	#if !note_hit and !area.get_parent().hit:
		#miss = true
		#printPrecision()
		#combo = 0
	#resetPrecision()

#func _on_bad_area_entered(area):
	#if !holding:
		#note_hit = false

func _on_killzone_area_entered(area):
	if !area.get_parent().hit:
		miss = true
		printPrecision()
		combo = 0
		resetPrecision()
