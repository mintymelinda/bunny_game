extends RigidBody3D

var _should_reset
var _starting_position: Vector3
var local_gravity
var _move_direction: Vector3 = Vector3.ZERO
var _last_strong_direction: Vector3 = Vector3.ZERO
var _model
var jump_impulse
var speed
var rotation_speed

func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	if _should_reset:
		state.transform.origin = _starting_position
		_should_reset = false
	
	local_gravity = state.total_gravity.normalized()
	
	if _move_direction.length() > 0.2:
		_last_strong_direction = _move_direction.normalized()
	
	_move_direction = _get_model_oriented_input()
	_orient_character_to_direction(_last_strong_direction, state.step)
		
	if is_jumping(state):
		_model.jump()
		apply_central_impulse(-local_gravity * jump_impulse)
	if is_on_floor(state) and not _model.is_falling():
		apply_central_force(_move_direction * speed)
	_model.velocity = state.linear_velocity
	

func _get_model_oriented_input() -> Vector3:
	var input_left_right := (
		Input.get_action_strength("move_left")
		- Input.get_action_strength("move_right")
	)
	var input_forward := Input.get_action_strength("move_up")
	var raw_input = Vector2(input_left_right, input_forward)
	
	var input := Vector3.ZERO
	input.x = raw_input.x * sqrt(1.0 - raw_input.y * raw_input.y / 2.0)
	input.z = raw_input.y * sqrt(1.0 - raw_input.x * raw_input.x / 2.0)
	return input

func _orient_character_to_direction(direction: Vector3, delta: float) -> void:
	var left_axis: Vector3 = -local_gravity.cross(direction)
	var rotation_basis := Basis(left_axis, -local_gravity, direction).orthonormalized()
	_model.transform.basis = _model.transform.basis.get_rotation_quat().slerp(
		rotation_basis, delta * rotation_speed
	)

func is_jumping(state):
	return false
	
func is_on_floor(state: PhysicsDirectBodyState3D):
	for contact in state.get_contact_count():
		var contact_normal = state.get_contact_local_normal(contact)
		if contact_normal.dot(-local_gravity) > 0.5:
			return true
	return false

func reset_position():
	pass
