extends SeedableCharacter
class_name Penguin

var last_direction = Vector3.ZERO
var waving = false
var slide = false

func initialize(g):
	super(g)
	
	blocking_types = ["food", "spawn", "house", "mountain"]
	
	if random:
		set_random_rotate_y()
		set_random_placement()

func _get_scaled_radius() -> float:
	return $CollisionShape3D.shape.radius * scale.x
	
func _process(delta: float) -> void:
	if not direction:
		if waving:
			Globals.switch_to_animation($Character/AnimationPlayer, "wave")
		else:
			Globals.switch_to_animation($Character/AnimationPlayer, "idle")
	else:
		if slide:
			Globals.switch_to_animation($Character/AnimationPlayer, "slide")
			slide = false
		else:
			Globals.switch_to_animation($Character/AnimationPlayer, "walk", true)

#func _get_random_direction() -> Vector3:
	#return (transform.basis * Vector3(2 * PI * randf(), 0, 0)).normalized()
#
#func reverse_direction(): 
	#direction *= -1

func _ready() -> void:
	if random:
		direction = _get_random_direction()

func _physics_process(delta: float) -> void:
	var target_velocity = Vector3.ZERO

	if direction:
		$Character.look_at(global_position - direction)
	
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed
	
	velocity = target_velocity
	move_and_slide()

func _on_collision_area_body_entered(body: Node3D) -> void:
	reverse_direction()

func _on_stop_and_wave_body_entered(body: Node3D) -> void:
	if body is Player:
		direction = Vector3.ZERO
		waving = true

func _on_stop_and_wave_body_exited(body: Node3D) -> void:
	if body is Player:
		waving = false
		slide = true
		if random:
			direction = _get_random_direction()
