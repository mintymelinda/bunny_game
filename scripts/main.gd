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
	player.camera.current = true
#
