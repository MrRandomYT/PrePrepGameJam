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


	# ========================================================
	# Register States
	# ========================================================

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


	# ========================================================
	# Start Default State
	# ========================================================

	change_state(default_state)


func _physics_process(delta: float) -> void:

	# ========================================================
	# Shared Physics
	# ========================================================

	movement_controller.apply_gravity(delta)
	movement_controller.update_timers(delta)


	# ========================================================
	# Current State
	# ========================================================

	if current_state:
		current_state.update(delta)


	# ========================================================
	# Move Player
	# ========================================================

	player.move_and_slide()


	# ========================================================
	# Update Ground State
	# ========================================================

	movement_controller.update_ground_state(delta)


func change_state(state_id: StringName) -> void:

	if not states.has(state_id):

		if state_id == default_state:
			push_error(
				"State '%s' does not exist!" % state_id
			)
			return

		push_warning(
			"State '%s' does not exist, using default state '%s'." % [
				state_id,
				default_state
			]
		)

		state_id = default_state


	# Don't restart the current state.
	if current_state == states[state_id]:
		return


	if current_state:
		current_state.exit()


	current_state = states[state_id]
	current_state.enter()


# ============================================================
# Jump Transition
# ============================================================

func change_to_jump(jump_type: JumpState.JumpType) -> void:
	var jump_state := states["JumpState"] as JumpState

	jump_state.jump_type = jump_type

	change_state("JumpState")
