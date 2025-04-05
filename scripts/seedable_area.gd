extends Node
class_name SeedableArea

@export var enabled: bool = false
@export var seedable_things: Array[PackedScene]

var ground = preload("res://scenes/ground.tscn").instantiate()
var seeded = false

func _ready() -> void:
	if not enabled:
		return
	
	add_child(ground)
	
	if not seeded:
		_seed_planet()

func _seed_planet() -> void:
	for seedable_thing in seedable_things:
		_seed(seedable_thing)

func _seed(seedableThing: PackedScene):
	var _s = seedableThing.instantiate()
	_s.initialize(ground)
	for index in range(_s.get_coverage()):
		_s = seedableThing.instantiate()
		_s.initialize(ground)
		ground.add(_s)
		add_child(_s)

	seeded = true
