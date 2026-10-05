extends CharacterBody2D

@export_range(0, 1000, 0.01, "hide_slider") var speed := 100.0
@export_range(0, 1000, 0.01, "hide_slider") var jump_velocity := 200.0
@export_subgroup("Extras")
@export_range(0, 1, 0.01, "prefer_slider") var jump_buffer_time := 0.1
@export_range(0, 1, 0.01, "prefer_slider") var jump_cut_multiplier := 0.5

var jump_buffer_timer := 0.0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if(Input.is_action_just_pressed("Jump")):
		jump_buffer_timer = jump_buffer_time
	
	if (jump_buffer_timer > 0.0):
		if (is_on_floor()):
			jump_buffer_timer = 0.0
			velocity.y = -jump_velocity
		else:
			jump_buffer_timer = maxf(jump_buffer_timer - delta, 0.0)
			
	if(Input.is_action_just_released("Jump") and velocity.y < 0):
		velocity.y *= jump_cut_multiplier

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("Left", "Right")
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()
