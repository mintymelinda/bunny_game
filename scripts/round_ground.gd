class_name RoundGround
extends StaticBody3D

var MIN
var MAX

var world_objects: Array[Node3D]

#func _physics_process(delta):
	#var direction = Vector3.ZERO
#
	#if Input.is_action_pressed("move_right"):
		#var angle = PI * 2 * 1 * delta
		#rotate_x(angle)
	#if Input.is_action_pressed("move_left"):
		#rotate_x(PI * 2 * -1 * delta)
	#if Input.is_action_pressed("move_back"):
		#rotate_y(PI * 2 * 1 * delta)
	#if Input.is_action_pressed("move_forward"):
		#rotate_y(PI * 2 * -1 * delta)
		#
	#var target_velocity = Vector3.ZERO
	##target_velocity.x = direction.x * speed * _get_scaled_radius()
	##target_velocity.z = direction.z * speed * _get_scaled_radius()
	#
	#if direction != Vector3.ZERO:
		#direction = direction.normalized()
		##look_at(direction)
		#var angle = position.angle_to(target_velocity)
		#rotate_x(angle)


#func initizalize():
	#pass
	## var radius = $Area.shape.radius * scale.x / 2

func get_random_position(blocking_types, radius: float, scaler = 1.0, y = 0.0) -> Vector3:
	for attempt in range(300):
		
		var new_position = Vector3(0, _get_scaled_radius(), 0)
		new_position = new_position.rotated(Vector3(1,0,0).normalized(), randf() * PI * 2)
		new_position = new_position.rotated(Vector3(0,0,1).normalized(), randf() * PI * 2)
		#slide(_get_scaled_radius() * Vector3.UP.normalized())
		#new_position.rotated(Vector3(1, 0, 1).normalized(), randf())
		# var new_position = Vector3(randf_range(MIN.x, MAX.x) * scaler, y, randf_range(MIN.z, MAX.z) * scaler)
		if not _position_occupied(blocking_types, radius, new_position):
			return new_position

	return Vector3(1, 1, 1)

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
	return 4 * PI * _get_scaled_radius() * _get_scaled_radius()

func _get_scaled_radius():
	return $Area.shape.radius * scale.x

func remove(node):
	world_objects.remove_at(world_objects.find(node))

func add(node):
	world_objects.append(node)
