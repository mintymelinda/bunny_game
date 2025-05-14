extends SeedableThing

func initialize(g):
	super(g)
	
	blocking_types = ["food", "spawn", "house", "mountain"]
	
	set_random_rotate_y()
	set_random_placement()

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("climber"):
		body.climbing = self

func _get_scaled_radius() -> float:
	return $Area3D/Area.shape.radius * scale.x
