extends AreaBase

func initialize():
	super()
	
	blocking_types = ["food", "spawn", "house"]
	
	set_random_rotate_y()
	set_random_placement()
