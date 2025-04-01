class_name Ground
extends StaticBody3D

var MIN
var MAX

var world_objects: Array[Node3D]

func initizalize(world_x, world_y , world_z):
	scale.x = world_x
	scale.y = world_y
	scale.z = world_z
	
	var x = $Area.shape.size.x * scale.x / 2
	var z = $Area.shape.size.z * scale.z / 2
	var y = $Area.shape.size.y * scale.y / 2
	MIN = Vector3(-x, y, -z)
	MAX = Vector3(x, y, z)

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

func get_coverage() -> float:
	return _get_area()
	
func _get_area():
	return ($Area.shape.size.x * scale.x) * ($Area.shape.size.z * scale.z)

func remove(node):
	world_objects.remove_at(world_objects.find(node))

func add(node):
	world_objects.append(node)
