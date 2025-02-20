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

var score = 0
var note_queue : Array
var note_hit

var miss = false
var bad = false
var good = false
var great = false
var perfect = false

func _unhandled_input(event):
	if event is InputEventKey:
		var hitList = checkHitboxes()
		var hitNote = hitList[0]
		var hitPrecision = hitList[1]
		if hitNote != null:
			hitNote = hitNote.get_parent()
			note_hit = false
			if event.is_action_pressed("Yellow"):
				if hitNote.type == 1:
					hitNote.queue_free()
					note_hit = true
			if event.is_action_pressed("Blue"):
				if hitNote.type == 2:
					hitNote.queue_free()
					note_hit = true
			if event.is_action_pressed("Green"):
				if hitNote.type == 3:
					hitNote.queue_free()
					note_hit = true
			if event.is_action_pressed("Red"):
				if hitNote.type == 4:
					hitNote.queue_free()
					note_hit = true
			if note_hit:
				var mult
				match hitPrecision:
					1: mult = 0.5
					2: mult = 1
					3: mult = 3
					4: mult = 5
				score += 10 * mult
				print(score)
		printPrecision()
		
func checkHitboxes() -> Array:
	var retArray = [null, 0]
	resetPrecision()
	if bad_hitbox.get_overlapping_areas().size() > 0:
		retArray = [bad_hitbox.get_overlapping_areas()[0], 1]
		bad = true
	if good_hitbox.get_overlapping_areas().size() > 0 and good_hitbox.get_overlapping_areas()[0] == retArray[0]:
		retArray = [good_hitbox.get_overlapping_areas()[0], 2]
		good = true
	if great_hitbox.get_overlapping_areas().size() > 0 and great_hitbox.get_overlapping_areas()[0] == retArray[0]:
		retArray = [great_hitbox.get_overlapping_areas()[0], 3]
		great = true
	if perfect_hitbox.get_overlapping_areas().size() > 0 and perfect_hitbox.get_overlapping_areas()[0] == retArray[0]:
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
	resetPrecision()

func _on_bad_area_entered(area):
	resetLabels()
	note_hit = false
