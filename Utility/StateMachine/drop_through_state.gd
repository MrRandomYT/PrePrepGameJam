extends State
class_name DropThroughState


func enter() -> void:
	animated_sprite.play("idle")

	# Start the drop-through timer.
	movement_controller.drop_through_timer = (
		movement_controller.drop_through_time
	)

	# Temporarily disable collision with layer 8.
	player.set_collision_mask_value(8, false)

	# Give the player a tiny downward push.
	# This makes sure we actually leave the platform.
	player.velocity.y = 50.0


func update(delta: float) -> void:

	# Keep falling until the drop-through timer expires.
	if movement_controller.drop_through_timer > 0.0:
		return


	# Restore collision with one-way platforms.
	player.set_collision_mask_value(8, true)

	# Continue normal falling.
	state_machine.change_state("FallState")
