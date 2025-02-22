class_name Player extends Entity

func _ready():
	pass

# NOTE: This is only a test btw
func _process(delta):
	if Input.is_action_just_pressed("ui_up"):
		do_attack_W()
	elif Input.is_action_just_pressed("ui_left"):
		do_attack_A()
	elif Input.is_action_just_pressed("ui_down"):
		do_attack_S()
	elif Input.is_action_just_pressed("ui_right"):
		do_attack_D()
	pass

func do_idle():
	state_machine.set_state("Idle")
	
func do_flying():
	state_machine.set_state("Flying")

func do_attack_W():
	state_machine.set_state("Attack_W")
	
func do_attack_A():
	state_machine.set_state("Attack_A")

func do_attack_S():
	state_machine.set_state("Attack_S")

func do_attack_D():
	state_machine.set_state("Attack_D")

func do_hold():
	state_machine.set_state("Hold")
