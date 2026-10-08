
if player.is_on_floor(): 
	if Input.get_axis("Left", "Right") != 0.0: [[Walk State]]
	else: [[Idle State]]
elif player.velocity.y < 0.0: [[Jump State]]
else: [[Fall State]]