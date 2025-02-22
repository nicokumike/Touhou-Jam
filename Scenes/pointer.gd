extends CharacterBody2D

@onready var noteGraphics = preload("res://Game/UI/Notes_Graphics/note_graphics.tscn")

@onready var scoreAmount = $"../ScoreAmount"
@onready var comboAmount = $"../ComboAmount"

var score = 0
var combo = 0
var note_queue : Array
var note_hit
var note_precision = 0

var precisionMult = 1
var comboMult = 1

var miss = false
#var bad = false
#var good = false
#var great = false
#var perfect = false
var holding = false

func _process(delta):
	$FlandreContactPoint.rotation_degrees += .5
	scoreAmount.text = str(score)
	comboAmount.text = str(combo)
	if holding:
		score += 1 * precisionMult * comboMult

func _unhandled_input(event):
	if event is InputEventKey:
		var hitList = checkNotes()
		var hitNote = hitList[0]
		var hitPrecision = hitList[1]
		var keyPress = checkPress(event)
		if hitNote != null and hitPrecision > 0 and keyPress > 0:
			note_hit = false
			if keyPress == hitNote.type:
				note_hit = true
			if note_hit:
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
				score += 10 * precisionMult * comboMult
				if hitNote.hold:
					holding = true
					hitNote.holdNote()
					hitNote.pointerObj = self
				else:
					hitNote.queue_free()
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
		
func checkNotes() -> Array:
	var retArray = [null, 0]
	var notes = get_tree().get_nodes_in_group("note")
	
	if notes.size() > 0:
		var closestNote = notes[0]
		var precision = closestNote.checkPosition()
		retArray = [notes[0], notes[0].checkPosition()]
		note_precision = precision
		#match precision:
			#1: bad = true
			#2: good = true
			#3: great = true
			#4: perfect = true
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
	#bad = false
	#good = false
	#great = false
	#perfect = false

func printPrecision():
	var noteLabel = noteGraphics.instantiate()
	add_child(noteLabel)
	noteLabel.initiate(note_precision)
	noteLabel.global_position = position
	noteLabel.global_position.y -= 100
	
	noteLabel.global_position.y += randf_range(-10, 10)
	noteLabel.global_position.x += randf_range(-10, 10)
	
	#resetLabels()
	#precisionLabelReset.wait_time = 0.5
	#if note_hit:
		#if perfect:
			#perfectLabel.visible = true
			#return
		#if great:
			#greatLabel.visible = true
			#return
		#if good:
			#goodLabel.visible = true
			#return
		#if bad:
			#badLabel.visible = true
			#return
	#if miss:
		#missLabel.visible = true
		#return

func _on_bad_area_exited(area):
	if !note_hit:
		miss = true
		printPrecision()
		combo = 0
	resetPrecision()

func _on_bad_area_entered(area):
	if !holding:
		note_hit = false
