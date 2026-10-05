extends Node
class_name StateMachine

@export var player: CharacterBody2D
@export var animation_player: AnimationPlayer

var current_state : State

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if (!player || !animation_player):
		push_error("Missing State Machine Requirenments!")
		push_warning("Disabling State Machine - Check Errors")
		set_process(false)
		set_physics_process(false)
		return
		
	for child in get_children():
		if child is State:
			child.setup(player, animation_player)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if current_state:
		current_state.update(delta)

# Function called my states to "request" a change
func change_state(new_state: State):
	if current_state:
		current_state.exit()
	
	current_state = new_state
	current_state.enter()
