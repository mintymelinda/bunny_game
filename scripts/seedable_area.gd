extends Node
class_name SeedableArea

@export var seedableThings: Array[PackedScene]

var ground = preload("res://scenes/ground.tscn").instantiate()
var seeded = false

func _ready() -> void:
	add_child(ground)
	if not seeded:
		_seed_planet()

func _seed_planet() -> void:
	for seedableThing in seedableThings:
		_seed(seedableThing)
	
func _seed(seedableThing: PackedScene):
	var _s = seedableThing.instantiate()
	_s.initialize(ground)
	for index in range(_s.get_coverage()):
		_s = seedableThing.instantiate()
		_s.initialize(ground)
		ground.add(_s)
		add_child(_s)
	
	seeded = true
