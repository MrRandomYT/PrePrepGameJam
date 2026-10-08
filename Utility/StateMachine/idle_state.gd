extends State
class_name IdleState


func enter() -> void:
	animated_sprite.play("idle")


func update(delta: float) -> void:

	# ========================================================
	# Stop Horizontal Movement
	# ========================================================

	player.velocity.x = move_toward(
		player.velocity.x,
		0.0,
		movement_controller.deceleration * delta
	)


	# ========================================================
	# Walk
	# ========================================================

	if Input.get_axis("Left", "Right") != 0.0:
		state_machine.change_state("WalkState")
		return


	# ========================================================
	# Normal Jump
	# ========================================================

	if Input.is_action_just_pressed("Jump"):
		state_machine.change_to_jump(
			JumpState.JumpType.NORMAL
		)
		return


	# ========================================================
	# Dash
	# ========================================================

	if Input.is_action_just_pressed("Dash"):
		if movement_controller.can_dash:
			state_machine.change_state("DashState")
			return


	# ========================================================
	# Left Ground
	# ========================================================

	if not player.is_on_floor():
		state_machine.change_state("FallState")
