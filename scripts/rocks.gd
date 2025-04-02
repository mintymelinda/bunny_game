extends Node3D

@export var scenes: Array[PackedScene]

var blocking_types

func initialize():
	#_seed_rocks()

func _seed_rocks():
	for scene in scenes:
		var rock = scene.instantiate()
		rock.initialize(blocking_types, false)
		for index in range(rock.get_coverage() / scenes.size()):
			rock = scene.instantiate()
			rock.initialize(blocking_types, false)
			Globals.add(rock)
			add_child(rock)

func _get_avg_rock_coverage() -> float:
	var area = 0.0
	for scene in scenes:
		var s = scene.instantiate()
		s.initialize(blocking_types, false)
		area += s._get_area()
	
	return area / scenes.size()
