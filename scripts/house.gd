extends AreaBase

func initialize(canopy, blocking_groups = null):
	super(canopy, blocking_groups)
	
	set_random_placement()

func _get_scaled_radius() -> float:
	return $House/Area.shape.radius * scale.x
