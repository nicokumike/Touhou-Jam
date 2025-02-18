extends CharacterBody2D

@onready var bad_hitbox = $Bad
@onready var good_hitbox = $Good
@onready var great_hitbox = $Great
@onready var perfect_hitbox = $Perfect

var score = 0
var note_queue : Array
var note_hit

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
			if event.is_action_pressed("A"):
				if hitNote.type == 1:
					hitNote.queue_free()
					note_hit = true
			if event.is_action_pressed("B"):
				if hitNote.type == 2:
					hitNote.queue_free()
					note_hit = true
			if event.is_action_pressed("C"):
				if hitNote.type == 3:
					hitNote.queue_free()
					note_hit = true
			if event.is_action_pressed("D"):
				if hitNote.type == 4:
					hitNote.queue_free()
					note_hit = true
			if note_hit:
				var mult
				match hitPrecision:
					1:
						mult = 0.5
					2:
						mult = 1
					3:
						mult = 3
					4:
						mult = 5
				score += 10 * mult
				print(score)

func checkHitboxes() -> Array:
	var auxArray = []
	var testPerfect : Array = perfect_hitbox.get_overlapping_areas()
	for t in testPerfect:
		t = t.get_parent()
		auxArray.append(t)
	testPerfect = auxArray
	auxArray = []
	var testGreat = great_hitbox.get_overlapping_areas()
	for t in testGreat:
		t = t.get_parent()
		auxArray.append(t)
	testGreat = auxArray
	auxArray = []
	var testGood = good_hitbox.get_overlapping_areas()
	for t in testGood:
		t = t.get_parent()
		auxArray.append(t)
	testGood = auxArray
	auxArray = []
	var testBad = bad_hitbox.get_overlapping_areas()
	for t in testBad:
		t = t.get_parent()
		auxArray.append(t)
	testBad = auxArray
	
	if bad_hitbox.get_overlapping_areas().size() > 0:
		return [bad_hitbox.get_overlapping_areas()[0], 1]
	if good_hitbox.get_overlapping_areas().size() > 0:
		return [good_hitbox.get_overlapping_areas()[0], 2]
	if great_hitbox.get_overlapping_areas().size() > 0:
		return [great_hitbox.get_overlapping_areas()[0], 3]
	if perfect_hitbox.get_overlapping_areas().size() > 0:
		return [perfect_hitbox.get_overlapping_areas()[0], 4]
	return [null, 0]

#func _on_bad_area_entered(area):
	#if area.get_parent().is_in_group("note"):
		#note_queue.append(area.get_parent())
		#bad = true
#
#func _on_bad_area_exited(area):
	#if area.get_parent().is_in_group("note"):
		#note_queue.pop_front()
		#bad = false
#
#func _on_good_area_entered(area):
	#if area.get_parent().is_in_group("note"):
		#good = true
		#
#func _on_good_area_exited(area):
	#if area.get_parent().is_in_group("note"):
		#good = false
#
#func _on_great_area_entered(area):
	#if area.get_parent().is_in_group("note"):
		#great = true
#
#func _on_great_area_exited(area):
	#if area.get_parent().is_in_group("note"):
		#great = false
#
#func _on_perfect_area_entered(area):
	#if area.get_parent().is_in_group("note"):
		#perfect = true
#
#func _on_perfect_area_exited(area):
	#if area.get_parent().is_in_group("note"):
		#perfect = false
