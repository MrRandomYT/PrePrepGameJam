extends State
class_name IdleState

func enter() -> void:
	print("Entered idle")
	animated_sprite.play("idle")
	

func update(delta: float) -> void:
	pass


func exit() -> void:
	print("Exited idle")
