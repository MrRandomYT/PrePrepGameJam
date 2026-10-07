extends State
class_name DashState


func enter() -> void:
	animated_sprite.play("idle")

	movement_controller.can_dash = false
	movement_controller.dash_timer = movement_controller.dash_time

	# Dash in facing direction.
	player.velocity.x = (
		movement_controller.orientation
		* movement_controller.dash_speed
	)

	# Preserve the original gravity damping behavior.
	player.velocity.y *= movement_controller.dash_gravity_damping


func update(delta: float) -> void:
	# Keep dash movement locked.
	player.velocity.x = (
		movement_controller.orientation
		* movement_controller.dash_speed
	)

	player.velocity.y *= movement_controller.dash_gravity_damping

	movement_controller.dash_timer -= delta

	if movement_controller.dash_timer <= 0.0:
		movement_controller.dash_timer = 0.0

		# Decide where we go after the dash.
		if player.is_on_floor():
			if Input.get_axis("Left", "Right") != 0.0:
				state_machine.change_state("WalkState")
			else:
				state_machine.change_state("IdleState")
		elif player.velocity.y < 0.0:
			state_machine.change_state("JumpState")
		else:
			state_machine.change_state("FallState")
