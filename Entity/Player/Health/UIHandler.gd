extends CanvasLayer
class_name UIHandler

@export var hazard_system : HazardSystem

func _ready() -> void:
	hazard_system.health_changed.connect(_on_health_changed)
	hazard_system.toxin_coins_changed.connect(_on_toxin_coins_changed)


func _on_health_changed(current: int, maximum: int) -> void:
	print("Health: ", current, " / ", maximum)


func _on_toxin_coins_changed(amount: int) -> void:
	print("Toxin Coins: ", amount)
