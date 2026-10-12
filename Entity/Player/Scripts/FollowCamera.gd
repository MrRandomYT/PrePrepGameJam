extends Camera2D
class_name FollowCamera

@export var follow_target: Node2D

@export var minimum: Vector2
@export var maximum: Vector2


func _process(_delta: float) -> void:
	if not is_instance_valid(follow_target):
		return

	global_position = follow_target.global_position

	global_position.x = clampf(global_position.x, minimum.x, maximum.x)
	global_position.y = clampf(global_position.y, minimum.y, maximum.y)
