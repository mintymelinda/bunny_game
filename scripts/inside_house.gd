extends Node3D

@onready var camera = $CameraPivot/Camera3D
@onready var player_spawn = $SpawnMarker

func _on_inside_door_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		Globals.set_location(Globals.location.outside_house, body)
		body.camera.current = true
