extends Node
class_name StateMachine

@export var player: CharacterBody2D
@export var animated_sprite: AnimatedSprite2D
@export var default_state: StringName

var current_state : State
var states: Dictionary[StringName, State] = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if (!player || !animated_sprite):
		push_error("Missing State Machine Requirenments!")
		push_warning("Disabling State Machine - Check Errors")
		set_process(false)
		set_physics_process(false)
		return
		
	for child in get_children():
		if child is State:
			child.setup(self, player, animated_sprite)
			
			if (states.has(child.state_id)):
				push_error("Duplicate State ID: {child.state_id}")
				continue
				
			states[child.state_id] = child

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if current_state:
		current_state.update(delta)

# Function called by states to request a change
func change_state(state_id: StringName) -> void:
	if (!states.has(state_id)):
		if(state_id != default_state):
			push_error("State '{state_id}' does not exist!")
			return
			
		push_warning("State '{state_id}' does not exist, using default state '{default_state}.'")
		state_id = default_state

	if (current_state):
		current_state.exit()

	current_state = states[state_id]
	current_state.enter()
