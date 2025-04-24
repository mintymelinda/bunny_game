extends SeedableCharacter
class_name Penguin

@export var speed = 2.0
@export var random = true

var direction = Vector3.ZERO
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
			_switch_to_animation("wave")
		else:
			_switch_to_animation("idle")
	else:
		if slide:
			_switch_to_animation("slide")
			slide = false
		else:
			_switch_to_animation("walk", true)

func _switch_to_animation(name: String, wait: bool = false):
	var animation_player = $Character/AnimationPlayer
	if wait and animation_player.is_playing():
		return

	if animation_player.current_animation != name:
		animation_player.play(name)

	if not animation_player.is_playing():
		animation_player.play(name)

func _get_random_direction() -> Vector3:
	return (transform.basis * Vector3(2 * PI * randf(), 0, 0)).normalized()

func reverse_direction(): 
	direction *= -1

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
