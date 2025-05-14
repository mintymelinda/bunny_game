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

func get_location() -> location:
	return current_location
	
func set_location(loc: location, player):
	if current_location != loc:
		current_location = loc
		location_changed.emit(player)

func switch_to_animation(animation_player: AnimationPlayer, animation: String, wait: bool = false):
	if wait and animation_player.is_playing():
		return

	# this might be handled automatically honestly
	if animation_player.current_animation != animation:
		animation_player.play(animation)

	if not animation_player.is_playing():
		animation_player.play(animation)

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
			return get_tree().get_first_node_in_group("inside_mountain").get_node("SpawnMarker").global_position
		_:
			return Vector3.ZERO
