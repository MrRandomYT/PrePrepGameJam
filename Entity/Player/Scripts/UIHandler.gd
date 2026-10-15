extends Control
class_name UIHandler

@export_subgroup("Health & Toxins")
@export var hearts_container: HBoxContainer
@export var heart_scene: PackedScene

var player_controller: PlayerController
var hearts: Array[Heart] = []

@export_subgroup("Android & Touch")
@export var is_touch: bool = false
@export var touch_controlls: PackedScene


func _ready() -> void:
	# ============================================================
	# Android & Touch
	# ============================================================
	if is_touch:
		if touch_controlls == null:
			push_warning("UIHandler: Assign TouchControlls.")
		else:
			var touch = touch_controlls.instantiate()
			add_child(touch)

	# ============================================================
	# Health & Toxins
	# ============================================================

	# Find the PlayerController if it hasn't been assigned.
	if player_controller == null:
		var player_node: Node = get_tree().get_first_node_in_group("player")
		player_controller = player_node as PlayerController

	if player_controller == null:
		push_warning("UIHandler: Could not find PlayerController.")
		return

	if player_controller.hazard_system == null:
		push_warning("UIHandler: PlayerController has no HazardSystem.")
		return

	if hearts_container == null:
		push_warning("UIHandler: Assign HeartsContainer.")
		return

	if heart_scene == null:
		push_warning("UIHandler: Assign Heart Scene.")
		return

	player_controller.hazard_system.health_changed.connect(_on_health_changed)
	player_controller.hazard_system.toxin_level_changed.connect(_on_toxin_level_changed)

	create_hearts()
	call_deferred(
		"update_hearts",
		player_controller.hazard_system.current_health,
		player_controller.hazard_system.max_health
	)


func create_hearts() -> void:
	# Remove existing hearts.
	for child in hearts_container.get_children():
		child.queue_free()

	hearts.clear()

	# One heart represents two health points.
	var heart_count: int = ceili(
		float(player_controller.hazard_system.max_health) / 2.0
	)

	for i in range(heart_count):
		var heart: Heart = heart_scene.instantiate() as Heart

		if heart == null:
			push_error("UIHandler: Heart Scene root must use Heart.gd.")
			return

		hearts_container.add_child(heart)
		hearts.append(heart)


func update_hearts(current: int, _maximum: int) -> void:
	var toxins: int = player_controller.hazard_system.toxin_level()

	for i in range(hearts.size()):
		# Each heart represents two health points.
		var health_for_heart: int = clampi(
			current - (i * 2),
			0,
			2
		)

		# Each heart represents two toxin levels.
		var toxins_for_heart: int = clampi(
			toxins - ((hearts.size() - 1 - i) * 2),
			0,
			2
		)

		hearts[i].set_heart_state(
			health_for_heart,
			toxins_for_heart
		)


func _on_health_changed(current: int, maximum: int) -> void:
	update_hearts(current, maximum)


func _on_toxin_level_changed(_toxin_level: int) -> void:
	update_hearts(
		player_controller.hazard_system.current_health,
		player_controller.hazard_system.max_health
	)
