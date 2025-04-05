extends AreaBase

func initialize(g):
	super(g)
	
	blocking_types = ["food", "spawn", "house", "rock", "water", "tree"]
	
	set_random_rotate_y()
	#set_random_placement()

func get_coverage() -> float:
	return 1.0

func _get_scaled_radius() -> float:
	return $Mountain/Area/Area.shape.radius * scale.x
