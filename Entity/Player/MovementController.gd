extends Node
class_name MovementController


@export var player: CharacterBody2D


func _ready() -> void:
	if !player:
		push_error("Missing Player Reference!")
		push_warning("Disabling Movement Controller.")
		set_process(false)
		set_physics_process(false)


# ============================================================
# Shared Physics
# ============================================================

func apply_gravity(delta: float) -> void:
	if !player.is_on_floor():
		player.velocity += player.get_gravity() * delta


func update_timers(delta: float) -> void:
	# Jump buffer
	if jump_buffer_timer > 0.0:
		jump_buffer_timer = maxf(
			jump_buffer_timer - delta,
			0.0
		)

	# Dash cooldown
	if dash_cooldown_timer > 0.0:
		dash_cooldown_timer = maxf(
			dash_cooldown_timer - delta,
			0.0
		)

	if drop_through_timer > 0.0:
		drop_through_timer = maxf(
			drop_through_timer - delta,
			0.0
		)


func update_ground_state(delta: float) -> void:
	if player.is_on_floor():
		# Restore abilities when landing.
		can_double_jump = double_jump
		can_wall_jump = wall_jump
		can_dash = dash

		# Start / refresh coyote timer.
		coyote_timer = coyote_time
	else:
		# Count down coyote time while airborne.
		coyote_timer = maxf(
			coyote_timer - delta,
			0.0
		)


# ============================================================
# Jump
# ============================================================

func request_jump() -> void:
	jump_buffer_timer = jump_buffer_time


func consume_jump_buffer() -> void:
	jump_buffer_timer = 0.0


# ============================================================
# Dash
# ============================================================

func start_dash() -> void:
	can_dash = false
	dash_timer = dash_time
	dash_cooldown_timer = dash_cooldown


func end_dash() -> void:
	dash_timer = 0.0


# ============================================================
# Config Data
# ============================================================

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

@export var allow_double_and_wall_jump := false


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

@export_subgroup("Drop Through")

@export var drop_through := true
@export var drop_through_time := 0.2


# ============================================================
# Runtime Data
# ============================================================

var jump_buffer_timer := 0.0
var coyote_timer := 0.0

var can_double_jump := false
var can_wall_jump := false

var can_dash := true
var dash_timer := 0.0
var dash_cooldown_timer := 0.0

var drop_through_timer := 0.0

# 1.0 = facing right
# -1.0 = facing left
var orientation := 1.0
