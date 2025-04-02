extends RigidBody3D

@export var speed = 1.0

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		var player = body
		if not player.power_ups.has("rock_destroy"):
			player.power_ups.append("rock_destroy")
		queue_free()

func _physics_process(delta: float) -> void:
	rotate_x(2 * PI * delta * speed)
	rotate_y(2 * PI * delta * speed)
