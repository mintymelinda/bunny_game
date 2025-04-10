extends Node3D
class_name Seedable

@export var density: float = 0.1
@export var size_scale: float = 1.0

var blocking_types
var ground

func initialize(g):
	scale.x = size_scale / g.get_parent().get_parent().scale.x
	scale.y = size_scale / g.get_parent().get_parent().scale.y
	scale.z = size_scale / g.get_parent().get_parent().scale.z
	ground = g

func set_random_rotate_y():
	rotate_y(randf() * PI)
	
func set_random_rotate_x():
	rotate_x(randf() * PI)

func set_random_placement():
	position = ground.get_random_position(blocking_types, _get_scaled_radius())

func get_coverage() -> float:
	return ground.get_coverage() / _get_area() * density

func _get_area():
	return PI * _get_scaled_radius() * _get_scaled_radius()

func _get_scaled_radius() -> float:
	return $Area.shape.radius * scale.x
	
