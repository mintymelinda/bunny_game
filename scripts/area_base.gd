class_name AreaBase
extends Node3D

@export var density: float = 0.1
@export var placement_scale: float = 0.9
@export var size_scale: float = 1.0

var surface
var blocking_types

func initialize(canopy, blocking_groups = null):
	surface = canopy

	scale.x = size_scale
	scale.y = size_scale
	scale.z = size_scale
	
	blocking_types = blocking_groups
	
	surface.add(self)

func set_random_rotate_y():
	rotate_y(randf() * PI)
	
func set_random_rotate_x():
	rotate_x(randf() * PI)

func set_random_placement():
	position = surface.get_random_position(blocking_types, _get_scaled_radius(), placement_scale)

func get_coverage() -> float:
	return surface.get_coverage() * placement_scale / _get_area() * density

func _get_area():
	return PI * _get_scaled_radius() * _get_scaled_radius()

func _get_scaled_radius() -> float:
	return $Area.shape.radius * scale.x
	
