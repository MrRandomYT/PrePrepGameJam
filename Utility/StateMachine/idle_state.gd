extends State
class_name IdleState

func enter() -> void:
	print("Entered idle")
	animation_player.play("idle")
	

func update(delta: float) -> void:
	pass


func exit() -> void:
	print("Exited idle")
