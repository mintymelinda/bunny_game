extends SeedableCharacter
class_name Squirrel

var last_direction = Vector3.ZERO
var climbing: Node3D = null

func initialize(g):
	super(g)
	
	blocking_types = ["food", "spawn", "house", "tree", "mountain"]
	
	if random:
		set_random_rotate_y()
		set_random_placement()

	
func _process(delta: float) -> void:
	if not climbing:
		Globals.switch_to_animation($Character/AnimationPlayer, "frolick")

func _ready() -> void:
	if random:
		direction = _get_random_direction()

func _physics_process(delta: float) -> void:
	var target_velocity = Vector3.ZERO

	if direction:
		$Character.look_at(direction)
	
	if climbing:
		$Character.look_at(climbing.position)

	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed
	
	velocity = target_velocity
	move_and_slide()

func _on_trunk_detector_body_entered(body: Node3D) -> void:
	if body.is_in_group("tree"):
		velocity = Vector3.ZERO # stop
		Globals.switch_to_animation($Character/AnimationPlayer, "climbing")
