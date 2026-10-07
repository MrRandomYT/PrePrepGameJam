extends State
class_name WalkState


func enter() -> void:
	animated_sprite.play("walk")


func update(delta: float) -> void:
	var direction := Input.get_axis("Left", "Right")

	# No horizontal input → idle.
	if direction == 0.0:
		state_machine.change_state("IdleState")
		return

	# Face movement direction.
	if direction > 0.0:
		movement_controller.orientation = 1.0
		animated_sprite.flip_h = false
	else:
		movement_controller.orientation = -1.0
		animated_sprite.flip_h = true

	# Accelerate toward target speed.
	var target_speed := direction * movement_controller.speed

	player.velocity.x = move_toward(
		player.velocity.x,
		target_speed,
		movement_controller.acceleration * delta
	)

	# Jump.
	if Input.is_action_just_pressed("Jump"):
		state_machine.change_state("JumpState")
		return

	# Dash.
	if Input.is_action_just_pressed("Dash"):
		if movement_controller.can_dash:
			state_machine.change_state("DashState")
			return

	# Walk state should only exist on the ground.
	if not player.is_on_floor():
		state_machine.change_state("FallState")
