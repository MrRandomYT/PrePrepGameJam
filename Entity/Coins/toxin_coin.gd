extends Area2D
class_name ToxinCoin

@export var hazard_system: HazardSystem
@export var coin_amount: int = 1


func _ready() -> void:
	body_entered.connect(_on_body_entered)

	if hazard_system == null:
		push_warning("ToxinCoin: Assign HazardSystem.")


func _on_body_entered(body: Node2D) -> void:
	if not body is CharacterBody2D:
		return

	if hazard_system == null:
		return

	# Grant Toxin Coins to HazardSystem™.
	hazard_system.collect_toxin_coins(coin_amount)

	# Remove the collected coin.
	queue_free()
