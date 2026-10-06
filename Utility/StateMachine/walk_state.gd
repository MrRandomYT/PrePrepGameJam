extends State
class_name WalkState

func enter() -> void:
	print("Entered WalkState")
	animated_sprite.play("walk")
	

func update(delta: float) -> void:
	var direction := Input.get_axis("Left", "Right")
	if(direction):
		if (direction > 0):
			movement_controller.orientation = 1.0
			animated_sprite.flip_h = false
		elif (direction < 0):
			movement_controller.orientation = -1.0
			animated_sprite.flip_h = true
			
		var target_speed := direction * movement_controller.speed
		player.velocity.x = move_toward(player.velocity.x, target_speed, movement_controller.acceleration * delta)
		
		if(Input.is_action_just_pressed("Jump")):
			state_machine.change_state("JumpState")
	else:
		state_machine.change_state("IdleState")
