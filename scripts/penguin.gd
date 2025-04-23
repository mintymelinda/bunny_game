extends SeedableCharacter
class_name Penguin

@export var speed = 2.0

var direction

func initialize(g):
	super(g)
	
	blocking_types = ["food", "spawn", "house", "mountain"]
	
	set_random_rotate_y()
	set_random_placement()

func _get_scaled_radius() -> float:
	return $CollisionShape3D.shape.radius * scale.x
	
func _process(delta: float) -> void:
	if not $Character/AnimationPlayer.is_playing():
		$Character/AnimationPlayer.play("ArmatureAction")

func _get_random_direction():
	return 2 * PI * randf()

func reverse_direction(): 
	direction *= -1

func _ready() -> void:
	direction = (transform.basis * Vector3(_get_random_direction(), 0, 0)).normalized()

func _physics_process(delta: float) -> void:
	var target_velocity = Vector3.ZERO
	$Character.look_at(global_position - direction)
	
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed
	
	velocity = target_velocity
	move_and_slide()
