extends Area2D
class_name CleansingStation

@export var hazard_system: HazardSystem

var player_in_range: bool = false


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

	if hazard_system == null:
		push_warning("CleansingStation: Assign HazardSystem.")


func _on_body_entered(body: Node2D) -> void:
	if not body is CharacterBody2D:
		return

	player_in_range = true


func _on_body_exited(body: Node2D) -> void:
	if not body is CharacterBody2D:
		return

	player_in_range = false


func _unhandled_input(event: InputEvent) -> void:
	if not player_in_range:
		return

	if event.is_action_pressed("Interact"):
		if hazard_system == null:
			return

		# Purify all collected Toxin Coins.
		var purified_amount: int = hazard_system.purify_toxin_coins()

		if purified_amount > 0:
			print("Purified ", purified_amount, " Toxin Coins!")
