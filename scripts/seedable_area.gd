extends Node3D
class_name SeedableArea

@export var enabled: bool = false
@export var use_ground = true
@export var use_water = true

var ground_scene = preload("res://scenes/ground.tscn")
var water_scene = preload("res://scenes/ground_water.tscn")

var ground
var water

func _ready() -> void:
	if not enabled:
		return

	ground = get_node_or_null("Ground")
	water = get_node_or_null("Water")

	if use_ground:
		if not ground:
			ground = ground_scene.instantiate()

		if not ground.is_inside_tree():
			add_child(ground)

	if use_water:
		if not water:
			water = water_scene.instantiate()
		
		if not water.is_inside_tree():
			add_child(water)

	_seed(_get_surface())
	
func _get_surface() -> Node3D:
	return ground if ground else water

func _seed(surface):
	for maybeSeedableThing in get_children():
		if maybeSeedableThing is SeedableThing:
			var seedable_thing = maybeSeedableThing
			seedable_thing.initialize(surface)
			for index in range(seedable_thing.get_coverage()):
				seedable_thing = seedable_thing.duplicate()
				seedable_thing.initialize(surface)
				surface.add(seedable_thing)
				add_child(seedable_thing)
		
			#free the template
			seedable_thing.queue_free()
			
func get_x():
	return _get_surface().world_x

func get_z():
	return _get_surface().world_z
