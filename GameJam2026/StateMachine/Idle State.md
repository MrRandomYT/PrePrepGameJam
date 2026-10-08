if Input.get_axis("Left", "Right") != 0.0: [[Walk State]]
if Input.is_action_just_pressed("Jump"): [[Jump State]]
if Input.is_action_just_pressed("Dash"): [[Dash State]]
if not player.is_on_floor(): [[Fall State]]