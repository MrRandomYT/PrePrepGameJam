extends Node

# ============================================================
# Scene Loading
# ============================================================

var next_spawn_point: StringName = &"Default"


func load_level(
	level_path: String,
	player_scene: PackedScene = null,
	spawn_point: StringName = &"Default"
) -> void:
	PauseManager.resume_game()
	
	# Load the requested scene.
	var error: Error = get_tree().change_scene_to_file(level_path)

	if error != OK:
		push_error(
			"SceneManager: Failed to load scene. Error: "
			+ str(error)
		)
		return

	# Only spawn a Player if a Player Scene was provided.
	if player_scene == null:
		return

	next_spawn_point = spawn_point

	await get_tree().scene_changed

	_spawn_player_at_spawn(player_scene)


func _spawn_player_at_spawn(player_scene: PackedScene) -> void:
	var current_scene: Node = get_tree().current_scene

	if current_scene == null:
		return

	# Find the requested spawn point inside World.
	var spawn_points: Node = current_scene.get_node_or_null(
		"World/SpawnPoints"
	)

	if spawn_points == null:
		return

	var spawn: Node2D = spawn_points.get_node_or_null(
		String(next_spawn_point)
	) as Node2D

	# Fall back to the default spawn point.
	if spawn == null:
		spawn = spawn_points.get_node_or_null("Default") as Node2D

	if spawn == null:
		return

	# Create a fresh Player instance.
	var player: Node = player_scene.instantiate()

	if not player is Node2D:
		player.free()
		return

	# Ensure the Player can be found by other scripts.
	player.add_to_group("player")

	# Add the Player to the level and position it at the spawn.
	current_scene.add_child(player)
	player.global_position = spawn.global_position
