extends State
class_name IdleState

func enter() -> void:
	print("Entered IdleState")
	animated_sprite.play("idle")
	

func update(delta: float) -> void:
	player.velocity.x = move_toward(player.velocity.x, 0.0, movement_controller.deceleration * delta)
	
	if(player.is_on_floor()):
		if(Input.get_axis("Left", "Right")):
			state_machine.change_state("WalkState")
	
	if(Input.is_action_just_pressed("Jump")):
		state_machine.change_state("JumpState")
