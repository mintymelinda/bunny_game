extends Node3D

func _on_inside_door_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		Globals.set_location(Globals.location.mountain, body)
		body.camera.current = true
