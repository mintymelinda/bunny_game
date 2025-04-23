extends SeedableThing

func initialize(g):
	super(g)
	
	blocking_types = ["spawn_platform"]
	
	set_random_placement()

func get_coverage() -> float:
	return 1.0
