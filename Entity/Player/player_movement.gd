extends CharacterBody2D

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
@export_range(0, 100, 0.01, "prefer_slider")
var dash_cooldown := 2.0
@export var dash := true

var jump_buffer_timer := 0.0 # Early Jump
var coyote_timer := 0.0 # Late Jump
var can_double_jump : bool # Double Jump
var can_wall_jump : bool # Double Jump

var can_dash := true # Dash
var dash_timer := 0.0
var dash_cooldown_timer := 0.0
var dash_direction: float:
	get: return -1.0 if $AnimatedSprite2D.flip_h else 1.0

func _physics_process(delta: float) -> void:
	Gravity(delta)
	Dash(delta)
	GroundCheck(delta)
	Jump(delta)
	Move(delta)
	
func Gravity(delta: float):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta 

func Dash(delta: float):
	if (Input.is_action_just_pressed("Dash") and can_dash and dash_cooldown_timer <= 0.0):
		can_dash = false
		dash_timer = dash_time
		dash_cooldown_timer = dash_cooldown
		velocity.x = dash_direction * dash_speed
		
	if (dash_cooldown_timer > 0.0):
		dash_cooldown_timer = maxf(dash_cooldown_timer - delta, 0.0)
		
	if (dash_timer > 0.0):
		dash_timer = maxf(dash_timer - delta, 0.0)
		velocity.x = dash_direction * dash_speed

func GroundCheck(delta: float):
	# Handle delayed jump
	if (is_on_floor()):
		if(can_double_jump != double_jump) : can_double_jump = double_jump
		if(can_wall_jump != wall_jump) : can_wall_jump = wall_jump
		can_dash = dash
		coyote_timer = coyote_time
	else:
		coyote_timer = maxf(coyote_timer - delta, 0.0)

func Jump (delta: float):
	# Handle jump input.
	if(Input.is_action_just_pressed("Jump")):
		jump_buffer_timer = jump_buffer_time
	
	# Execute Jump
	if (jump_buffer_timer > 0.0):
		if is_on_floor() or coyote_timer > 0:
			jump_buffer_timer = 0.0
			coyote_timer = 0.0
			velocity.y = -jump_velocity
		elif is_on_wall() and can_wall_jump:
			jump_buffer_timer = 0.0
			can_wall_jump = false
			velocity.y = -jump_velocity
		elif can_double_jump:
			jump_buffer_timer = 0.0
			can_double_jump = false
			velocity.y = -jump_velocity
		else:
			jump_buffer_timer = maxf(jump_buffer_timer - delta, 0.0)
			
	# Jump height manipulation
	if(Input.is_action_just_released("Jump") and velocity.y < 0):
		velocity.y *= jump_cut_multiplier

func Move (delta: float):
	# Normal horizontal movement
	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("Left", "Right")
	if direction:
		var target_speed := direction * speed
		velocity.x = move_toward(velocity.x, target_speed, acceleration * delta)
	else:
		velocity.x = move_toward(velocity.x, 0.0, deceleration * delta)

	move_and_slide()
