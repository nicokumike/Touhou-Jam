class_name Player extends Entity

func _ready():
	pass

# NOTE: This is only a test btw
func _process(delta):
	if Input.is_action_just_pressed("Yellow"):
		do_attack_up()
	elif Input.is_action_just_pressed("Blue"):
		do_attack_left()
	elif Input.is_action_just_pressed("Green"):
		do_attack_down()
	elif Input.is_action_just_pressed("Red"):
		do_attack_right()
	pass

func do_idle():
	state_machine.set_state("Idle")
	
func do_flying():
	state_machine.set_state("Flying")

func do_attack_up():
	state_machine.set_state("Attack_UP")
	
func do_attack_down():
	state_machine.set_state("Attack_DOWN")

func do_attack_left():
	state_machine.set_state("Attack_LEFT")

func do_attack_right():
	state_machine.set_state("Attack_RIGHT")

func do_hold():
	state_machine.set_state("Hold")

func do_ohohoh():
	state_machine.set_state("OHOHOH")
