extends Node3D

@export var scenes: Array[PackedScene]

var surface: Ground
var blocking_types

func initialize(surf, blocking_groups = null):
	surface = surf
	blocking_types = blocking_groups
	_seed_rocks()

func _seed_rocks():
	for scene in scenes:
		var rock = scene.instantiate()
		rock.initialize(surface)
		for index in range(rock.get_coverage() / scenes.size()):
			rock = scene.instantiate()
			rock.initialize(surface, blocking_types)
			surface.add(rock)
			add_child(rock)

func _get_avg_rock_coverage() -> float:
	var area = 0.0
	for scene in scenes:
		var s = scene.instantiate()
		s.initialize(surface)
		area += s._get_area()
	
	return area / scenes.size()
