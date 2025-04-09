extends Node
class_name SeedableArea

@export var enabled: bool = false

var ground = preload("res://scenes/ground.tscn").instantiate()

func _ready() -> void:
	if not enabled:
		return
	
	add_child(ground)
	_seed()

func _seed():
	for maybeSeedableThing in get_children():
		if maybeSeedableThing is SeedableThing:
			var seedable_thing = maybeSeedableThing
			seedable_thing.initialize(ground)
			for index in range(seedable_thing.get_coverage()):
				seedable_thing = seedable_thing.duplicate()
				seedable_thing.initialize(ground)
				ground.add(seedable_thing)
				add_child(seedable_thing)
		
			#free the template
			seedable_thing.queue_free()
