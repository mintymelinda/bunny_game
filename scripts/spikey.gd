extends CharacterBody3D

@export var speed = 1.0

@export var direction: Vector3 = Vector3.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _physics_process(delta: float) -> void:
	var target_velocity = Vector3.ZERO

	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed
	
	velocity = target_velocity
	move_and_slide()


func _on_area_3d_body_entered(body: Node3D) -> void:
	direction *= -1
