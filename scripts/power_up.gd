extends RigidBody3D

@export var speed = 1.0
@export var power_up_name = ""

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		body.power_ups.append(power_up_name)
	
		# DialogueManager.show_dialogue_balloon(load("res://dialogue/dialogue.dialogue"))
		queue_free()

func _physics_process(delta: float) -> void:
	rotate_x(2 * PI * delta * speed)
	rotate_y(2 * PI * delta * speed)
