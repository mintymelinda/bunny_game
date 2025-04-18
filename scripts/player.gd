extends CharacterBody3D

signal hit
signal jump
signal moved
signal select_power_up
signal ate(combo)

@export var speed = 14
@export var fall_acceleration = 75
@export var jump_impulse = 20
@export var bounce_impulse = 16
@export var max_combo = 5
@export var slam_impulse = 64
@export var rotation_speed = 2

@onready var camera = $CameraPivot/Camera

var selected_power_up = "none"
var power_ups: Array = [selected_power_up]

var last_position
var target_velocity = Vector3.ZERO
var combo = 0

func _physics_process(delta):
	var direction = Vector3.ZERO
	
	## debug shortcut to reload environment
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
	if Input.is_action_just_pressed("item"):
		get_next_item()
		
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
			target_velocity.y = jump_impulse * (1 + combo) * 0.5
			jump.emit()
	
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
		
		if selected_power_up == "rock_destroy":
			if collision.get_collider().is_in_group("rock"):
				if Vector3.UP.dot(collision.get_normal()) > 0.1:
					var rock = collision.get_collider()
					rock.smash()
					bounce()
				break

		if collision.get_collider().is_in_group("food"):
			var food = collision.get_collider()
			if Vector3.UP.dot(collision.get_normal()) > 0.1:
				food.eat(combo)
				ate.emit(combo)
				bounce()
				break
		
		moved.emit(position)
		
	velocity = target_velocity
	move_and_slide()
	
	$Pivot.rotation.x = PI / 6 * velocity.y / jump_impulse

func get_next_item():
	var next_index = power_ups.find(selected_power_up) + 1
	if next_index >= power_ups.size():
		next_index = 0
	selected_power_up = power_ups.get(next_index)
	select_power_up.emit(selected_power_up)

func bounce():
	combo += 1
	combo = min(combo, max_combo)
	target_velocity.y = bounce_impulse * (1 + combo) * 0.5

func die():
	combo = 0
	hit.emit()
	
	if true:
		position = Vector3(0, 10, 0)
		velocity = Vector3.ZERO
	else:
		queue_free()
