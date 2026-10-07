extends Node
class_name StateMachine


@export var player: CharacterBody2D
@export var animated_sprite: AnimatedSprite2D
@export var movement_controller: MovementController
@export var default_state: StringName


var current_state: State
var states: Dictionary[StringName, State] = {}


func _ready() -> void:
	if !player || !animated_sprite || !movement_controller:
		push_error("Missing State Machine Requirements!")
		push_warning("Disabling State Machine - Check Errors.")
		set_process(false)
		set_physics_process(false)
		return

	# Register all states that are children of the StateMachine.
	for child in get_children():
		if child is State:
			child.setup(
				self,
				player,
				animated_sprite,
				movement_controller
			)

			if states.has(child.state_id):
				push_error(
					"Duplicate State ID: '%s'" % child.state_id
				)
				continue

			states[child.state_id] = child

	# Start in the default state.
	change_state(default_state)


func _physics_process(delta: float) -> void:
	# --------------------------------------------------------
	# Shared physics
	# --------------------------------------------------------

	movement_controller.apply_gravity(delta)

	# Update timers such as jump buffer and dash cooldown.
	movement_controller.update_timers(delta)


	# --------------------------------------------------------
	# Current state
	# --------------------------------------------------------

	if current_state:
		current_state.update(delta)


	# --------------------------------------------------------
	# Move the player
	# --------------------------------------------------------

	player.move_and_slide()


	# --------------------------------------------------------
	# Update persistent movement information
	# --------------------------------------------------------

	movement_controller.update_ground_state(delta)


func change_state(state_id: StringName) -> void:
	# Make sure the requested state exists.
	if !states.has(state_id):

		# The default state itself is missing.
		if state_id == default_state:
			push_error(
				"State '%s' does not exist!" % state_id
			)
			return

		# Requested state doesn't exist.
		push_warning(
			"State '%s' does not exist, using default state '%s'." % [
				state_id,
				default_state
			]
		)

		state_id = default_state


	# Don't restart the same state unnecessarily.
	if current_state == states[state_id]:
		return


	# Exit the old state.
	if current_state:
		current_state.exit()


	# Enter the new state.
	current_state = states[state_id]
	current_state.enter()
