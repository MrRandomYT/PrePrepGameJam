extends Node
class_name MovementController

@export var player : CharacterBody2D

func _ready() -> void:
	if !player:
		push_error("Missing Player Reference!")
		push_warning("Disabling Movement Controller.")
		set_process(false)
		set_physics_process(false)

func _physics_process(delta: float) -> void:
		if !player.is_on_floor():
			player.velocity += player.get_gravity() * delta
			player.move_and_slide()

# Config Data

@export_subgroup("Movement")
@export_range(0, 1000, 0.01, "hide_slider")
var speed := 100.0
@export_range(0, 10000, 0.01, "hide_slider")
var acceleration := 1000.0
@export_range(0, 10000, 0.01, "hide_slider")
var deceleration := 800.0

@export_subgroup("Jumping")
@export_range(0, 1000, 0.01, "hide_slider")
var jump_velocity := 200.0
@export_range(0, 1, 0.01, "prefer_slider")
var jump_buffer_time := 0.1
@export_range(0, 1, 0.01, "prefer_slider")
var coyote_time := 0.1
@export_range(0, 1, 0.01, "prefer_slider")
var jump_cut_multiplier := 0.5
@export var double_jump := true
@export var wall_jump := true

@export_subgroup("Dash")
@export_range(0, 2000, 0.01, "hide_slider")
var dash_speed := 300.0
@export_range(0, 1, 0.01, "prefer_slider")
var dash_time := 0.15
@export_range(0, 60, 0.01, "prefer_slider")
var dash_cooldown := 2.0
@export_range(0, 1, 0.01, "prefer_slider")
var dash_gravity_damping := 0.2
@export var dash := true

# Runtime Data
var jump_buffer_timer := 0.0 # Early Jump
var coyote_timer := 0.0 # Late Jump
var can_double_jump : bool # Double Jump
var can_wall_jump : bool # Wall Jump

var can_dash := true # Dash
var dash_timer := 0.0
var dash_cooldown_timer := 0.0

var orientation := 1.0
# Getting replaced as I make states handle logic
var dash_direction: float:
	get: return -1.0 if $AnimatedSprite2D.flip_h else 1.0
