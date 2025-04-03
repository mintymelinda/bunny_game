extends AreaBase

func initialize(g):
	super(g)
	
	blocking_types = ["food", "water", "tree", "rock", "spawn"]
	
	set_random_placement()

func _get_scaled_radius() -> float:
	return $House/Area.shape.radius * scale.x

func get_coverage() -> float:
	return 1.0
