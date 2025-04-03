extends Node

var saved_world_scene = "res://scenes/populated_world.tscn"
var world_scene = "res://scenes/world.tscn"
var inside_house_scene = "res://scenes/inside_house.tscn"

var world
var inside_house

func _ready():
	_go_to_world()
	$UserInterface/Retry.hide()

func retry():
	$FoodTimer.stop()
	# $UserInterface/Retry.show()

func _on_player_hit() -> void:
	# retry()
	_go_to_world()

func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("ui_accept") and $UserInterface/Retry.visible:
		_go_to_world()

func _on_player_inside_door() -> void:
	_go_to_world()
	$Player/CameraPivot/Camera3D.current = true

func _on_player_outside_door() -> void:
	_go_to_house()

func _on_player_jump() -> void:
	$UserInterface/Accent/ComboLabel._on_ground_touched()

func _on_player_moved(pos) -> void:
	$UserInterface/Accent/PositionLabel._on_position_updated(pos)

func _on_player_select_power_up(power_up) -> void:
	$UserInterface/Accent/PowerUpLabel._on_updated(power_up)

func _go_to_world():
	if not world:
		var world_file = saved_world_scene if FileAccess.file_exists(saved_world_scene) else world_scene
		Globals.change_scene_to(world_file, _on_world_loaded.bind())
	else:
		_on_world_loaded(world)

func _go_to_house():
	if not inside_house:
		Globals.change_scene_to(inside_house_scene, _on_house_loaded.bind())
	else:
		_on_house_loaded(inside_house)

func _on_house_loaded(scene):
	inside_house = scene
	inside_house.initialize()
	remove_child(world)
	add_child(inside_house)
	
func _on_world_loaded(scene):
	world = scene
	remove_child(inside_house)
	add_child(world)
