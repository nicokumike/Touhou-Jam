class_name Player extends Entity

func _ready():
	pass

func _process(delta):
	if Input.is_action_pressed("ui_up"):
		state_machine.change_state("WindBrace")
	elif Input.is_action_just_pressed("ui_down"):
		state_machine.change_state("Attack_D")
	elif Input.is_action_just_pressed("ui_left"):
		state_machine.change_state("Attack_D")
	elif Input.is_action_just_pressed("ui_right"):
		state_machine.change_state("Attack_D")
	pass
