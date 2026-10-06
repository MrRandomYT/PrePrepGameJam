extends State
class_name JumpState

func enter() -> void:
	movement_controller.jump_buffer_timer = movement_controller.jump_buffer_time
	print("Entered JumpState")
	animated_sprite.play("idle")
	

func update(delta: float) -> void:
	# Handle jump input.
	if (movement_controller.jump_buffer_timer > 0.0):
		if player.is_on_floor() or movement_controller.coyote_timer > 0:
			movement_controller.jump_buffer_timer = 0.0
			movement_controller.coyote_timer = 0.0
			player.velocity.y = -movement_controller.jump_velocity
		elif player.is_on_wall() and movement_controller.can_wall_jump:
			movement_controller.jump_buffer_timer = 0.0
			movement_controller.can_wall_jump = false
			player.velocity.y = -movement_controller.jump_velocity
		elif movement_controller.can_double_jump:
			movement_controller.jump_buffer_timer = 0.0
			movement_controller.can_double_jump = false
			player.velocity.y = -movement_controller.jump_velocity
		else:
			movement_controller.jump_buffer_timer = maxf(movement_controller.jump_buffer_timer - delta, 0.0)
			
	# Jump height manipulation
	if(Input.is_action_just_released("Jump") and player.velocity.y < 0):
		player.velocity.y *= movement_controller.jump_cut_multiplier
		
	# Exit
	if (player.velocity.y >= 0):
		state_machine.change_state("IdleState")
