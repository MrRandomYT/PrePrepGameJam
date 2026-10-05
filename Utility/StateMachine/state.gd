extends Node
class_name State

var player: CharacterBody2D
var animation_player: AnimationPlayer

func setup(player: CharacterBody2D, animation_player: AnimationPlayer) -> void:
	self.player = player
	self.animation_player = animation_player

func enter() -> void:
	pass
	
func exit() -> void:
	pass
	
func update(delta: float) -> void:
	pass
