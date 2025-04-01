extends Node

@export var inside_house_scene: PackedScene
@export var world_scene: PackedScene

@export var world_x: float = 60
@export var world_z: float = 60
@export var world_y: float = 2

var x_size;
var z_size;

var world 
var inside_house

func _ready():
	world = world_scene.instantiate()
	add_child(world)
	world.initialize(world_x, world_y, world_z)
	$UserInterface/Retry.hide()

func retry():
	$FoodTimer.stop()
	# $UserInterface/Retry.show()

func _on_player_hit() -> void:
	# retry()
	_go_to_world()
	
func _go_to_world():
	remove_child(inside_house)
	add_child(world)
	
func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("ui_accept") and $UserInterface/Retry.visible:
		_go_to_world()

func _on_player_inside_door() -> void:
	_go_to_world()
	$Player/CameraPivot/Camera3D.current = true

func _on_player_outside_door() -> void:
	remove_child(world)
	inside_house = inside_house_scene.instantiate()
	inside_house.initialize()
	add_child(inside_house)

func _on_player_jump() -> void:
	$UserInterface/Accent/ComboLabel._on_ground_touched()

func _on_player_moved(pos) -> void:
	$UserInterface/Accent/PositionLabel._on_position_updated(pos)

func _on_player_select_power_up(power_up) -> void:
	$UserInterface/Accent/PowerUpLabel._on_updated(power_up)
