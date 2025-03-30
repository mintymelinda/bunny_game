extends AreaBase

func initialize(canopy, blocking_groups = null):
	super(canopy, blocking_groups)
	
	set_random_placement()
	set_random_rotate_y()
	set_random_rotate_x()
