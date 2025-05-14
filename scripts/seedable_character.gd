extends CharacterBody3D
class_name SeedableCharacter

@export var quantity: int = 0
@export var density: float = 0.1
@export var size_scale: float = 1.0

@export var speed = 2.0

@export var random: bool = true
@export var direction: Vector3


var blocking_types
var ground

func initialize(g):
	scale.x = size_scale / g.scale.x
	scale.y = size_scale / g.scale.y
	scale.z = size_scale / g.scale.z
	ground = g

func _get_random_direction() -> Vector3:
	return (transform.basis * Vector3(2 * PI * randf(), 0, 0)).normalized()
	## why is transform.basis needed? this could be global?
	#return Vector3(2 * PI * randf(), 0, 0).normalized()

func reverse_direction(): 
	direction *= -1

func set_random_rotate_y():
	rotate_y(randf() * PI)
	
func set_random_rotate_x():
	rotate_x(randf() * PI)

func set_random_placement():
	position = ground.get_random_position(blocking_types, _get_scaled_radius())

func get_coverage() -> float:
	if quantity > 0:
		return quantity

	return ground.get_coverage() * ground.scale.x / _get_area() * density

func _get_area():
	return PI * _get_scaled_radius() * _get_scaled_radius()

func _get_scaled_radius() -> float:
	return $Area.shape.radius * scale.x
	
