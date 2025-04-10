class_name Ground
extends StaticBody3D

@export var enabled = true

@onready var area = $Area
@onready var world_x = area.shape.size.x * scale.x
@onready var world_z = area.shape.size.z * scale.z
@onready var world_y = area.shape.size.y * scale.y
@onready var MIN = Vector3(-world_x  / 2.0, world_y / 2.0, -world_z / 2.0)
@onready var MAX = Vector3(world_x  / 2.0, world_y / 2.0, world_z / 2.0)

var world_objects: Array[Node3D]

func get_random_position(blocking_types, radius: float, y = 0.0) -> Vector3:
	for attempt in range(100):
		var new_position = Vector3(randf_range(MIN.x, MAX.x), y, randf_range(MIN.z, MAX.z))
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

func get_coverage() -> float:
	return _get_area()
	
func _get_area() -> float:
	return world_x * world_z
	
func remove(node):
	world_objects.remove_at(world_objects.find(node))

func add(node):
	world_objects.append(node)
