extends CharacterBody3D

signal hit
signal outside_door
signal inside_door

@export var speed = 14
@export var fall_acceleration = 75
@export var jump_impulse = 20
@export var bounce_impulse = 16
@export var max_combo = 5
@export var slam_impulse = 64

var last_position
var target_velocity = Vector3.ZERO
var combo = 0

func _physics_process(delta):
	var direction = Vector3.ZERO
	
	# debug shortcut to reload environment
	if Input.is_action_just_pressed("butt_slam"):
		die()
	
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_back"):
		direction.z += 1
	if Input.is_action_pressed("move_forward"):
		direction.z -= 1
		
	if direction != Vector3.ZERO:
		direction = direction.normalized()
		$Pivot.basis = Basis.looking_at(direction)
		$Pivot/Character/AnimationPlayer.speed_scale = 4
	else:
		$Pivot/Character/AnimationPlayer.speed_scale = 1
		
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed
	
	if is_on_floor():
		if direction != Vector3.ZERO:
			$Pivot/Character/AnimationPlayer.play("walk")
		else:
			$Pivot/Character/AnimationPlayer.play("stand")
			
		if Input.is_action_just_pressed("jump"):
			combo = max(1, combo - 1)
			# $/root/Main/UserInterface/ComboLabel._on_ground_touched()
			target_velocity.y = jump_impulse	* (1 + combo) * 0.5
	
	if not is_on_floor():
		target_velocity.y = target_velocity.y - (fall_acceleration * delta)
		$Pivot/Character/AnimationPlayer.play("fly")
		
	for index in range(get_slide_collision_count()):
		var collision = get_slide_collision(index)
		if collision.get_collider() == null:
			continue
		if collision.get_collider().is_in_group("water"):
			die()
			break

		if collision.get_collider().is_in_group("food"):
			var food = collision.get_collider()
			if Vector3.UP.dot(collision.get_normal()) > 0.1:
				food.eat(combo)
				combo += 1
				combo = min(combo, max_combo)
				target_velocity.y = bounce_impulse * (1 + combo) * 0.5
				break
		
		if collision.get_collider().is_in_group("inside_door"):
			if Vector3.MODEL_REAR.dot(collision.get_normal()) > 0.1:
				target_velocity = Vector3.ZERO
				position = last_position
				inside_door.emit()
				break

		if collision.get_collider().is_in_group("outside_door"):
			if Vector3.MODEL_FRONT.dot(collision.get_normal()) > 0.1:
				target_velocity = Vector3.ZERO
				if not last_position || last_position.distance_to(position) > 2:
					last_position = position
					
				position = Vector3.ZERO
				outside_door.emit()
				break
		
	velocity = target_velocity
	move_and_slide()
	
	$Pivot.rotation.x = PI / 6 * velocity.y / jump_impulse
		
func die():
	combo = 0
	hit.emit()
	queue_free()
