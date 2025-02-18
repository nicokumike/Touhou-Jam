extends CharacterBody2D

var score = 0
var note_queue : Array
var note_hit

var bad = false
var good = false
var great = false
var perfect = false

func _unhandled_input(event):
	if note_queue.size() > 0:
		note_hit = false
		if event.is_action_pressed("A"):
			if note_queue.back().type == 1:
				var note = note_queue.back()
				note_queue.pop_back()
				note.queue_free()
				note_hit = true
		if event.is_action_pressed("B"):
			if note_queue.back().type == 2:
				var note = note_queue.back()
				note_queue.pop_back()
				note.queue_free()
				note_hit = true
		if event.is_action_pressed("C"):
			if note_queue.back().type == 3:
				var note = note_queue.back()
				note_queue.pop_back()
				note.queue_free()
				note_hit = true
		if event.is_action_pressed("D"):
			if note_queue.back().type == 4:
				var note = note_queue.back()
				note_queue.pop_back()
				note.queue_free()
				note_hit = true
		if note_hit:
			var mult = 1
			if bad: mult = 0.5
			if good: mult = 1
			if great: mult = 3
			if perfect: mult = 5
			score += 10 * mult
			print(score)

func _on_bad_area_entered(area):
	if area.get_parent().is_in_group("note"):
		note_queue.append(area.get_parent())
		bad = true

func _on_bad_area_exited(area):
	if area.get_parent().is_in_group("note"):
		note_queue.pop_front()
		bad = false

func _on_good_area_entered(area):
	if area.get_parent().is_in_group("note"):
		good = true
		
func _on_good_area_exited(area):
	if area.get_parent().is_in_group("note"):
		good = false

func _on_great_area_entered(area):
	if area.get_parent().is_in_group("note"):
		great = true

func _on_great_area_exited(area):
	if area.get_parent().is_in_group("note"):
		great = false

func _on_perfect_area_entered(area):
	if area.get_parent().is_in_group("note"):
		perfect = true

func _on_perfect_area_exited(area):
	if area.get_parent().is_in_group("note"):
		perfect = false
