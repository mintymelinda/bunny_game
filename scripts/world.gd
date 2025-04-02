extends Node
class_name World

@export var world_elements: Array[PackedScene]

@onready var ground

var seeded = false

func _ready() -> void:
	if not seeded:
		_seed_planet()

func _seed_planet() -> void:
	for world_element in world_elements:
		#var element = world_element.instantiate()
		await _seed(world_element)
		#add_child(element)

#func _on_food_timer_timeout() -> void:
	#_make_food()
	
func _seed(world_element: PackedScene):
	var _s = world_element.instantiate()
	for index in range(_s.get_coverage()):
		_s = world_element.instantiate()
		_s.initialize()
		Globals.add(_s)
		add_child(_s)
	
	seeded = true

func _on_timer_timeout() -> void:
	var node_to_save = self
	var scene = PackedScene.new()
	scene.pack(node_to_save)
	scene.set_script(null)
	#print_tree()
	#ResourceSaver.save(scene, "res://scenes/populated_world.tscn")
