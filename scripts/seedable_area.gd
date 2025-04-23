extends Node3D
class_name SeedableArea

func _ready() -> void:
	_seed()

func _seed():
	var surface = get_parent()
	if not surface is Ground:
		return
	for seedable_thing in _get_seedable():
		seedable_thing.initialize(surface)
		remove_child(seedable_thing)
		for index in range(seedable_thing.get_coverage()):
			seedable_thing.initialize(surface)
			surface.add(seedable_thing)
			add_child(seedable_thing)
			seedable_thing = seedable_thing.duplicate()
	
	#for seedable_thing in _get_seedable():
		#seedable_thing.queue_free()

func _get_seedable():
	var seedable: Array[Node] = []
	for maybe_seedable in get_children():
		if maybe_seedable is SeedableThing or maybe_seedable is SeedableCharacter:
			seedable.append(maybe_seedable)
	return seedable
