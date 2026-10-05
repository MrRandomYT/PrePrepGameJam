extends State
class_name IdleState

func enter() -> void:
	animated_sprite.play("idle")
	

func update(_delta: float) -> void:
	if(player.velocity.x != 0):
		state_machine.change_state("WalkState")
