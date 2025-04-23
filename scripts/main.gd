extends Node

var saved_world_scene = "res://scenes/populated_world.tscn"

@onready var map_camera = $MapCamera
@onready var player = $Player

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("map"):
		if map_camera.current:
			$GUI.show()
			player.camera.current = true
		else:
			$GUI.hide()
			map_camera.current = true

func _ready():
	Globals.set_location(Globals.location.mountain, $Player)
	player.global_position = Globals.location_position()
	player.camera.current = true
