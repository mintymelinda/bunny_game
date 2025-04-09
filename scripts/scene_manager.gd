extends Node

@onready var world = $World
@onready var inside_house = $InsideHouse
@onready var inside_mountain = $InsideMountain

func _ready():
	Globals.location_changed.connect(_on_location_changed.bind())

func _on_location_changed(player):
	if Globals.get_location() == Globals.location.inside_house:
		if world.is_inside_tree():
			call_deferred("remove_child", world)
		if inside_mountain.is_inside_tree():
			call_deferred("remove_child", inside_mountain)
		
		if not inside_house.is_inside_tree():
			add_child(inside_house)
		
		inside_house.camera.current = true
	
	elif Globals.get_location() == Globals.location.inside_mountain:
		if world.is_inside_tree():
			call_deferred("remove_child", world)
			
		if inside_house.is_inside_tree():
			call_deferred("remove_child", inside_house)
	
		if not inside_mountain.is_inside_tree():
			add_child(inside_mountain)
			
		player.camera.current = true
	else:
		if inside_house.is_inside_tree():
			call_deferred("remove_child", inside_house)
		if inside_mountain.is_inside_tree():
			call_deferred("remove_child", inside_mountain)
		
		if not world.is_inside_tree():
			add_child(world)
			
	player.global_position = Globals.location_position()
