extends State
class_name JumpState


enum JumpType {
	NORMAL,
	DOUBLE,
	WALL
}


var jump_type := JumpType.NORMAL


func enter() -> void:
	animated_sprite.play("idle")


	# ========================================================
	# Perform Jump
	# ========================================================

	player.velocity.y = -movement_controller.jump_velocity


	# ========================================================
	# Consume Correct Ability
	# ========================================================

	match jump_type:

		JumpType.NORMAL:
			# Normal jump consumes coyote time.
			movement_controller.coyote_timer = 0.0


		JumpType.DOUBLE:
			# Consume double jump.
			movement_controller.can_double_jump = false

			# If double + wall jumps are NOT independent,
			# consume the wall jump too.
			if not movement_controller.allow_double_and_wall_jump:
				movement_controller.can_wall_jump = false


		JumpType.WALL:
			# Consume wall jump.
			movement_controller.can_wall_jump = false

			# If double + wall jumps are NOT independent,
			# consume the double jump too.
			if not movement_controller.allow_double_and_wall_jump:
				movement_controller.can_double_jump = false


	# Jump input has been consumed.
	movement_controller.jump_buffer_timer = 0.0


func update(delta: float) -> void:

	# ========================================================
	# Jump Cut
	# ========================================================

	if Input.is_action_just_released("Jump"):
		if player.velocity.y < 0.0:
			player.velocity.y *= movement_controller.jump_cut_multiplier


	# ========================================================
	# Horizontal Air Movement
	# ========================================================

	var direction := Input.get_axis("Left", "Right")


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


	# ========================================================
	# Dash
	# ========================================================

	if Input.is_action_just_pressed("Dash"):
		if movement_controller.can_dash:
			state_machine.change_state("DashState")
			return


	# ========================================================
	# Apex → Fall
	# ========================================================

	if player.velocity.y >= 0.0:
		state_machine.change_state("FallState")
