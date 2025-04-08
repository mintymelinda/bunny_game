extends Node

signal location_changed

var loading_screen = preload("res://scenes/loading_screen.tscn")
var next_scene: String = "res://scenes/loading_screen.tscn"

var return_address

var current_location = location.start
enum location {
	start,
	inside_house,
	outside_house,
	mountain,
	inside_mountain
}

func change_scene_to(scene: String, callback):
	next_scene = scene
	var loading = loading_screen.instantiate()
	loading.scene_loaded.connect(callback)
	if not loading.get_parent():
		add_child(loading)
		
func set_return_address(position: Vector3):
	return_address = position
	
func get_return_address() -> Vector3:
	return return_address

func get_location() -> location:
	return current_location
	
func set_location(loc: location):
	if current_location != loc:
		current_location = loc
		location_changed.emit()

func location_position() -> Vector3:
	match current_location:
		location.start:
			return get_tree().get_first_node_in_group("spawn").global_position
		location.inside_house:
			return get_tree().get_first_node_in_group("inside_house").get_node("SpawnMarker").global_position
		location.outside_house:
			return get_tree().get_first_node_in_group("house").get_node("SpawnMarker").global_position
		location.mountain:
			return get_tree().get_first_node_in_group("mountain").get_node("SpawnMarker").global_position
		location.inside_mountain:
			if not get_tree().get_first_node_in_group("inside_mountain"):
				get_tree().change_scene_to_packed(load("res://scenes/inside_mountain.tscn"))
				
			return get_tree().get_first_node_in_group("inside_mountain").get_node("SpawnMarker").global_position
		_:
			return Vector3.ZERO
		
			
