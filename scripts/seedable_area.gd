extends Node3D
class_name SeedableArea

@export var enabled: bool = true
@export var use_ground = true
@export var use_water = false

var ground
var water

func _ready() -> void:
	if not enabled:
		return
#
	if use_water:
		water = get_parent().get_node_or_null("Water")
	
	if use_ground:
		ground = get_parent().get_node_or_null("Ground")

	if use_ground and ground:
		ground = ground.duplicate()
		add_child(ground)
	if use_water and water:
		water = water.duplicate()
		add_child(water)

	if _get_surface():
		_seed(_get_surface())
	
func _get_surface() -> Node3D:
	return ground if ground else water

func _seed(surface):
	for maybeSeedableThing in get_children():
		if maybeSeedableThing is Seedable:
			var seedable_thing = maybeSeedableThing
			seedable_thing.initialize(surface)
			for index in range(seedable_thing.get_coverage()):
				seedable_thing = seedable_thing.duplicate()
				seedable_thing.initialize(surface)
				surface.add(seedable_thing)
				add_child(seedable_thing)
		
			#free the template
			seedable_thing.queue_free()
