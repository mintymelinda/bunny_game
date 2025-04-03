extends Node3D

@export var scaler = 3.0


func initialize():
	scale.x = scaler
	scale.y = scaler
	scale.z = scaler
	 
	$CameraPivot/Camera3D.current = true


func _on_inside_door_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		var player = body
		player.inside_door.emit()
