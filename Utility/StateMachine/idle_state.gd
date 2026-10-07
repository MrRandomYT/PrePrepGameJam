extends State
class_name IdleState


func enter() -> void:
	animated_sprite.play("idle")


func update(delta: float) -> void:
	# Stop horizontal movement.
	player.velocity.x = move_toward(
		player.velocity.x,
		0.0,
		movement_controller.deceleration * delta
	)

	# Start walking.
	if Input.get_axis("Left", "Right") != 0.0:
		state_machine.change_state("WalkState")
		return

	# Start jump.
	if Input.is_action_just_pressed("Jump"):
		state_machine.change_state("JumpState")
		return

	# Start dash.
	if Input.is_action_just_pressed("Dash"):
		if movement_controller.can_dash:
			state_machine.change_state("DashState")
			return

	# We left the ground.
	if not player.is_on_floor():
		state_machine.change_state("FallState")
