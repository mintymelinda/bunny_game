extends Node

var loading_screen = preload("res://scenes/loading_screen.tscn")
var next_scene: String = "res://scenes/loading_screen.tscn"

@export var world_x = 60
@export var world_y = 1
@export var world_z = 60

var MIN = Vector3(-world_x  / 2.0, world_y / 2.0, -world_z / 2.0)
var MAX = Vector3(world_x  / 2.0, world_y / 2.0, world_z / 2.0)

var world_objects: Array[Node3D]

func get_coverage() -> float:
	return _get_area()
	
func _get_area() -> float:
	return world_x * world_z

func change_scene_to(scene: String, callback):
	next_scene = scene
	var loading = loading_screen.instantiate()
	loading.scene_loaded.connect(callback)
	if not loading.get_parent():
		add_child(loading)

func get_random_position(blocking_types, radius: float, scaler = 1.0, y = 0.0) -> Vector3:
	for attempt in range(100):
		var new_position = Vector3(randf_range(MIN.x + radius, MAX.x - radius) * scaler, y, randf_range(MIN.z + radius, MAX.z - radius) * scaler)
		if not _position_occupied(blocking_types, radius, new_position):
			return new_position
	return Vector3.ZERO

func _position_occupied(blocking_types, radius: float, target_position) -> bool:
	for obj in world_objects:
		if is_blocking(obj, blocking_types):
			if obj.position.distance_squared_to(target_position) < (obj._get_scaled_radius() + radius) * (obj._get_scaled_radius() + radius):
				return true
	return false

func is_blocking(obj, blocking_types):
	if blocking_types == null:
		return false
		
	for blocking_type in blocking_types:
		if obj.get_groups().has(blocking_type):
			return true
	return false
	
func remove(node):
	Globals.world_objects.remove_at(Globals.world_objects.find(node))

func add(node):
	Globals.world_objects.append(node)
