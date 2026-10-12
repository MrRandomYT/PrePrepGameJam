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
	_state_machine: StateMachine,
	_player: CharacterBody2D,
	_animated_sprite: AnimatedSprite2D,
	_movement_controller: MovementController
) -> void:
	self.state_machine = _state_machine
	self.player = _player
	self.animated_sprite = _animated_sprite
	self.movement_controller = _movement_controller

func enter() -> void:
	pass
	
func exit() -> void:
	pass
	
func update(_delta: float) -> void:
	pass
