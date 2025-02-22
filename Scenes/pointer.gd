extends CharacterBody2D

@onready var bad_hitbox = $Bad
@onready var good_hitbox = $Good
@onready var great_hitbox = $Great
@onready var perfect_hitbox = $Perfect

@onready var missLabel = $"../MissLabel"
@onready var badLabel = $"../BadLabel"
@onready var goodLabel = $"../GoodLabel"
@onready var greatLabel = $"../GreatLabel"
@onready var perfectLabel = $"../PerfectLabel"
@onready var precisionLabelReset = $PrecisionLabelReset

@onready var scoreAmount = $"../ScoreAmount"
@onready var comboAmount = $"../ComboAmount"

var score = 0
var combo = 0
var note_queue : Array
var note_hit

var miss = false
var bad = false
var good = false
var great = false
var perfect = false

func _process(delta):
	scoreAmount.text = str(score)
	comboAmount.text = str(combo)
	

func _unhandled_input(event):
	if event is InputEventKey:
		#var hitList = checkHitboxes()
		var hitList = checkNotes()
		var hitNote = hitList[0]
		var hitPrecision = hitList[1]
		var keyPress = checkPress(event)
		if hitNote != null and hitPrecision > 0:
			#hitNote = hitNote.get_parent()
			note_hit = false
			if keyPress == hitNote.type:
				note_hit = true
			#if event.is_action_pressed("Yellow"):
				#if hitNote.type == 1:
					#note_hit = true
			#if event.is_action_pressed("Blue"):
				#if hitNote.type == 2:
					#note_hit = true
			#if event.is_action_pressed("Green"):
				#if hitNote.type == 3:
					#note_hit = true
			#if event.is_action_pressed("Red"):
				#if hitNote.type == 4:
					#note_hit = true
			if note_hit:
				var precisionMult = 1
				var comboMult = 1
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
				hitNote.queue_free()
			else:
				miss = true
				combo = 0
		else:
			if keyPress != 0:
				miss = true
				combo = 0
		printPrecision()
		
func checkNotes() -> Array:
	var retArray = [null, 0]
	var notes = get_tree().get_nodes_in_group("note")
	
	if notes.size() > 0:
		var closestNote = notes[0]
		var precision = closestNote.checkPosition()
		retArray = [notes[0], notes[0].checkPosition()]
		match precision:
			1: bad = true
			2: good = true
			3: great = true
			4: perfect = true
	return retArray
		
func checkPress(event) -> int:
	if event.is_action_pressed("Yellow"):
		return 1
	if event.is_action_pressed("Blue"):
		return 2
	if event.is_action_pressed("Green"):
		return 3
	if event.is_action_pressed("Red"):
		return 4
	return 0
		
func checkHitboxes() -> Array:
	var retArray = [null, 0]
	resetPrecision()
	if bad_hitbox.get_overlapping_areas().size() > 0:
		retArray = [bad_hitbox.get_overlapping_areas()[0], 1]
		bad = true
	if good_hitbox.get_overlapping_areas().size() > 0:
		retArray = [good_hitbox.get_overlapping_areas()[0], 2]
		good = true
	if great_hitbox.get_overlapping_areas().size() > 0:
		retArray = [great_hitbox.get_overlapping_areas()[0], 3]
		great = true
	if perfect_hitbox.get_overlapping_areas().size() > 0:
		retArray = [perfect_hitbox.get_overlapping_areas()[0], 4]
		perfect = true
	return retArray

func resetPrecision():
	miss = false
	bad = false
	good = false
	great = false
	perfect = false

func resetLabels():
	missLabel.visible = false
	badLabel.visible = false
	goodLabel.visible = false
	greatLabel.visible = false
	perfectLabel.visible = false

func printPrecision():
	resetLabels()
	precisionLabelReset.wait_time = 0.5
	if note_hit:
		if perfect:
			perfectLabel.visible = true
			return
		if great:
			greatLabel.visible = true
			return
		if good:
			goodLabel.visible = true
			return
		if bad:
			badLabel.visible = true
			return
	if miss:
		missLabel.visible = true
		return

func _on_bad_area_exited(area):
	if !note_hit:
		miss = true
		printPrecision()
		combo = 0
	resetPrecision()

func _on_bad_area_entered(area):
	resetLabels()
	note_hit = false

func _on_precision_label_reset_timeout():
	resetLabels()
