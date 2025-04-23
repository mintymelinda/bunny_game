extends SeedableThing

func initialize(g):
	super(g)
	
	blocking_types = ["food", "spawn", "house", "mountain"]
	
	set_random_rotate_y()
	set_random_placement()
