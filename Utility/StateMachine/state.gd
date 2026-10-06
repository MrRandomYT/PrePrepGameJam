extends Node
class_name State

var state_id: StringName:
	get:
		return get_script().get_global_name()

var state_machine: StateMachine
var player: CharacterBody2D
var animated_sprite: AnimatedSprite2D
var movement_controller: MovementController

func setup(
	state_machine: StateMachine,
	player: CharacterBody2D,
	animated_sprite: AnimatedSprite2D,
	movement_controller: MovementController
) -> void:
	self.state_machine = state_machine
	self.player = player
	self.animated_sprite = animated_sprite
	self.movement_controller = movement_controller

func enter() -> void:
	pass
	
func exit() -> void:
	pass
	
func update(delta: float) -> void:
	pass
