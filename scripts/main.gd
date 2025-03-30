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
	world.initialize(world_x, world_z, world_y)
	add_child(world)
	$UserInterface/Retry.hide()

func retry():
	$FoodTimer.stop()
	# $UserInterface/Retry.show()

func _on_player_hit() -> void:
	# retry()
	get_tree().reload_current_scene()
	
func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("ui_accept") and $UserInterface/Retry.visible:
		remove_child(inside_house)
		add_child(world)

func _on_player_inside_door() -> void:
	remove_child(inside_house)
	add_child(world)

func _on_player_outside_door() -> void:
	remove_child(world)
	inside_house = inside_house_scene.instantiate()
	add_child(inside_house)
