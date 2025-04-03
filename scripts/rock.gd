extends AreaBase

func initialize(g):
	super(g)
	
	blocking_types = ["food", "water", "tree", "rock", "spawn", "house"]
	
	set_random_placement()
	set_random_rotate_y()
	set_random_rotate_x()

func smash():
	queue_free()
