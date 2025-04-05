extends Node

var saved_world_scene = "res://scenes/populated_world.tscn"
var world = preload("res://scenes/world.tscn").instantiate()


@onready var player_camera = $Player/CameraPivot/Camera
@onready var map_camera = $MapCamera
@onready var player = $Player

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("map"):
		if map_camera.current:
			$GUI.hide()
			player_camera.current = true
		else:
			$GUI.show()
			map_camera.current = true

func _ready():
	add_child(world)
	Globals.set_location(Globals.location.start)
	player.global_position = Globals.location_position()
	#_go_to_world()
#
#func _on_player_hit() -> void:
	#_go_to_world()
#
#func _on_player_inside_door() -> void:
	#_go_to_world()
#
#func _on_player_outside_door() -> void:
	#_go_to_house()
#
#func _go_to_world():
	#Globals.set_location(Globals.location.outside_house)
	#player.global_position = Globals.location_position()
	#
#func _go_to_house():
	#Globals.set_location(Globals.location.inside_house)
	#player.global_position = Globals.location_position()
