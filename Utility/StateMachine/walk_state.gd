extends State
class_name WalkState

func enter() -> void:
	animated_sprite.play("walk")
	

func update(_delta: float) -> void:
	if (player.velocity.x > 0):
		animated_sprite.flip_h = false
	elif (player.velocity.x < 0):
		animated_sprite.flip_h = true
	else:
		state_machine.change_state("IdleState")
