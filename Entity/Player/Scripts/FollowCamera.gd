extends Camera2D
class_name FollowCamera

@export var follow_target: Node2D
@export var minimum: Vector2
@export var maximum: Vector2

func _process(_delta: float) -> void:
	if not is_instance_valid(follow_target):
		return

	var target_pos := follow_target.global_position

	target_pos.x = clampf(target_pos.x, minimum.x, maximum.x)
	target_pos.y = clampf(target_pos.y, minimum.y, maximum.y)

	global_position = target_pos
