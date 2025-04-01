extends Node3D

@export var scaler = 3.0

func initialize():
	scale.x = scaler
	scale.y = scaler
	scale.z = scaler
	 
	$CameraPivot/Camera3D.current = true
