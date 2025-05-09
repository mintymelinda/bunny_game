extends SeedableThing

func initialize(g):
	super(g)
	
	blocking_types = ["food", "water", "tree", "rock", "spawn"]
	
	#set_random_placement()
	position = Vector3.ZERO

func _get_scaled_radius() -> float:
	return $House/Area.shape.radius * scale.x

func get_coverage() -> float:
	return 1.0

func _on_outside_door_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		Globals.set_location(Globals.location.inside_house, body)
