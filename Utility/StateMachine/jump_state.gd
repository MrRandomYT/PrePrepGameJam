extends State
class_name JumpState


func enter() -> void:
	animated_sprite.play("idle")

	# A JumpState entry means an actual jump happens NOW.
	player.velocity.y = -movement_controller.jump_velocity

	# Consume the appropriate jump resource.
	if not player.is_on_floor() and movement_controller.coyote_timer <= 0.0:
		movement_controller.can_double_jump = false

	# Consume coyote time.
	movement_controller.coyote_timer = 0.0

	# Consume buffered jump.
	movement_controller.jump_buffer_timer = 0.0


func update(delta: float) -> void:
	# Jump cut.
	if Input.is_action_just_released("Jump") and player.velocity.y < 0.0:
		player.velocity.y *= movement_controller.jump_cut_multiplier

	# Horizontal air movement.
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

	# Dash.
	if Input.is_action_just_pressed("Dash"):
		if movement_controller.can_dash:
			state_machine.change_state("DashState")
			return

	# Reached apex.
	if player.velocity.y >= 0.0:
		state_machine.change_state("FallState")
