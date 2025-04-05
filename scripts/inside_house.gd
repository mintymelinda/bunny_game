extends Node3D

@export var scaler = 3.0
@onready var camera = $CameraPivot/Camera3D
@onready var player_spawn = $SpawnMarker

func initialize():
	scale.x = scaler
	scale.y = scaler
	scale.z = scaler

func _on_inside_door_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		Globals.set_location(Globals.location.outside_house)
		body.global_position = Globals.location_position()
		body.camera.current = true
