extends Node
class_name SeedableArea

@export var seedableThings: Array[PackedScene]

var seeded = false
@onready var ground_area = $Ground/Area

func _ready() -> void:
	if not seeded:
		_seed_planet()

func _seed_planet() -> void:
	for seedableThing in seedableThings:
		_seed(seedableThing)
	
func _seed(seedableThing: PackedScene):
	var _s = seedableThing.instantiate()
	for index in range(_s.get_coverage()):
		_s = seedableThing.instantiate()
		_s.initialize()
		Globals.add(_s)
		add_child(_s)
	
	seeded = true
