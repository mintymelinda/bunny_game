extends Node3D
class_name World

@onready var houses = get_tree().get_nodes_in_group("house")
var inside_house = preload("res://scenes/inside_house.tscn")
var house_scene = preload("res://scenes/house.tscn")

var inside
var house

func _ready() -> void:
	Globals.location_changed.connect(_on_location_changed.bind())

func _on_location_changed():
	if Globals.get_location() == Globals.location.inside_house:
		for _house in houses:
			if _house.get_parent():
				_house.get_parent().call_deferred("remove_child", _house)

		if house:
			remove_child(house)
			house.queue_free()

		if not inside:
			inside = inside_house.instantiate()
			inside.initialize()

		add_child(inside)
		inside.camera.current = true
	else:
		if inside and inside.is_inside_tree():
			call_deferred("remove_child", inside)
		
		if not house:
			house = house_scene.instantiate()

		add_child(house)

func _on_timer_timeout() -> void:
	var node_to_save = self
	var scene = PackedScene.new()
	scene.pack(node_to_save)
	scene.set_script(null)
	#print_tree()
	#ResourceSaver.save(scene, "res://scenes/populated_world.tscn")
