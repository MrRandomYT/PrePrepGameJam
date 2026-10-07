extends State
class_name FallState


func enter() -> void:
	animated_sprite.play("idle")


func update(delta: float) -> void:
	var direction := Input.get_axis("Left", "Right")

	# -------------------------
	# Horizontal air movement
	# -------------------------

	if direction != 0.0:
		if direction > 0.0:
			movement_controller.orientation = 1.0
			animated_sprite.flip_h = false
		else:
			movement_controller.orientation = -1.0
			animated_sprite.flip_h = true

		var target_speed := direction * movement_controller.speed

		player.velocity.x = move_toward(
			player.velocity.x,
			target_speed,
			movement_controller.acceleration * delta
		)
	else:
		player.velocity.x = move_toward(
			player.velocity.x,
			0.0,
			movement_controller.deceleration * delta
		)

	# -------------------------
	# Jump input
	# -------------------------

	if Input.is_action_just_pressed("Jump"):

		# Coyote jump.
		if movement_controller.coyote_timer > 0.0:
			state_machine.change_state("JumpState")
			return

		# Wall jump.
		if player.is_on_wall() and movement_controller.can_wall_jump:
			movement_controller.can_wall_jump = false

			# Push away from wall.
			var wall_normal := player.get_wall_normal()
			player.velocity.x = wall_normal.x * movement_controller.speed

			state_machine.change_state("JumpState")
			return

		# Double jump.
		if movement_controller.can_double_jump:
			movement_controller.can_double_jump = false
			state_machine.change_state("JumpState")
			return

		# Otherwise buffer the jump.
		movement_controller.jump_buffer_timer = (
			movement_controller.jump_buffer_time
		)

	# -------------------------
	# Jump buffer
	# -------------------------

	if movement_controller.jump_buffer_timer > 0.0:
		if player.is_on_floor():
			state_machine.change_state("JumpState")
			return

	# -------------------------
	# Dash
	# -------------------------

	if Input.is_action_just_pressed("Dash"):
		if movement_controller.can_dash:
			state_machine.change_state("DashState")
			return

	# -------------------------
	# Landing
	# -------------------------

	if player.is_on_floor():
		if movement_controller.jump_buffer_timer > 0.0:
			state_machine.change_state("JumpState")
		elif direction != 0.0:
			state_machine.change_state("WalkState")
		else:
			state_machine.change_state("IdleState")
