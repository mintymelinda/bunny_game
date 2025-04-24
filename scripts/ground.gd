class_name Ground
extends StaticBody3D

@export var enabled = true

var world_objects: Array[Node3D]

func get_random_position(blocking_types, radius: float, y = 0.0) -> Vector3:
	var MIN = Vector3(-get_x()  / 2.0, get_y() / 2.0, -get_z() / 2.0)
	var MAX = Vector3(get_x()  / 2.0, get_y() / 2.0, get_z() / 2.0)
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
	return get_x() * get_z()

func set_x(x: float):
	$Area.mesh.size.x = x

func get_x() -> float:
	return $Area.mesh.size.x * scale.x

func set_y(y: float):
	$Area.mesh.size.y = y

func get_y() -> float:
	return $Area.mesh.size.y * scale.y

func set_z(z: float):
	$Area.mesh.size.z = z

func get_z() -> float:
	return $Area.mesh.size.z * scale.z

func remove(node):
	world_objects.remove_at(world_objects.find(node))

func add(node):
	world_objects.append(node)


func _on_area_3d_body_exited(body: Node3D) -> void:
	if body is Penguin:
		body.reverse_direction()


func _on_area_3d_2_body_entered(body: Node3D) -> void:
	pass # Replace with function body.
