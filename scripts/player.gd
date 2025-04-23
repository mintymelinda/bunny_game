extends CharacterBody3D

signal hit
signal jump
signal moved
signal select_power_up
signal ate(combo)

@export var max_camera_angle = 80.0
@export var min_camera_angle = -22.0

@export var speed = 14
@export var fall_acceleration = 75
@export var jump_impulse = 20
@export var bounce_impulse = 16
@export var max_combo = 5
@export var slam_impulse = 64
@export var rotation_speed = 2

@export var horizontal_sensitivity = 0.5
@export var vertical_sensitivity = 0.5
var zoom_factor = 0
@export var zoom_factors = [0.5, 1.0, 5.0]
@export var min_zoom = 2.0
@export var max_zoom = 80.0

@onready var animation_player = $Pivot/Character/AnimationPlayer
@onready var camera = $SpringArm3D/CameraPivot/Camera
@onready var camera_pivot = $SpringArm3D/CameraPivot
@onready var spring_arm = $SpringArm3D
@onready var visuals = $Pivot

var selected_power_up = "none"
var power_ups: Array = [selected_power_up]

var last_position
var target_velocity = Vector3.ZERO
var combo = 0

var direction = Vector3.ZERO

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
func _input(event: InputEvent) -> void:
	if not camera.current:
		rotate_y(deg_to_rad(0))
		return

	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * horizontal_sensitivity))
		visuals.rotate_y(deg_to_rad(event.relative.x * horizontal_sensitivity))
		
		camera_pivot.rotate_x(deg_to_rad(-event.relative.y * vertical_sensitivity))
		
		# lock y and z, clamp x
		var camera_rotation = camera_pivot.rotation_degrees
		camera_rotation.x = clampf(camera_rotation.x, min_camera_angle, max_camera_angle)
		camera_rotation.y = clampf(camera_rotation.y, 0, 0)
		camera_rotation.z = clampf(camera_rotation.z, 0, 0)
		camera_pivot.rotation_degrees = camera_rotation
	
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == MOUSE_BUTTON_MIDDLE:
				zoom_factor += 1
				if zoom_factor >= zoom_factors.size():
					zoom_factor = 0
			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
				spring_arm.spring_length -= zoom_factors[zoom_factor]
			if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				spring_arm.spring_length += zoom_factors[zoom_factor]
				
			spring_arm.spring_length = clampf(spring_arm.spring_length, min_zoom, max_zoom)

func _unhandled_input(event: InputEvent) -> void:
	# debug shortcut to reload environment
	if Input.is_action_just_pressed("butt_slam"):
		die()
	
	# change items
	if Input.is_action_just_pressed("item"):
		get_next_item()

	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if Input.is_action_just_pressed("jump"):
		combo = max(1, combo - 1)
		target_velocity.y = jump_impulse * (1 + combo) * 0.5
		jump.emit()

func _physics_process(delta):
	if direction:
		visuals.look_at(global_position + direction)
		animation_player.speed_scale = 4
	else:
		animation_player.speed_scale = 1
		
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed
	
	if is_on_floor():
		if direction:
			if animation_player.current_animation != "walk":
				animation_player.play("walk")
		else:
			if animation_player.current_animation != "stand":
				animation_player.play("stand")

	if not is_on_floor():
		target_velocity.y = target_velocity.y - (fall_acceleration * delta)
		if animation_player.current_animation != "fly":
			animation_player.play("fly")
		
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
