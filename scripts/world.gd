extends Node

@export var fence_scene: PackedScene
@export var food_scene: PackedScene
@export var ground_scene: PackedScene
@export var house_scene: PackedScene
@export var rocks_scene: PackedScene
@export var tree_scene: PackedScene
@export var water_scene: PackedScene
@export var spawn_scene: PackedScene

var ground

func initialize(x, y, z):
	ground = ground_scene.instantiate()
	ground.initizalize(x, y, z)
	add_child(ground)
	
	_seed_planet()
	
	# $/root/Main/UserInterface/Retry.hide()

func _seed_planet() -> void:
	_make_spawn_location()
	
	if house_scene:
		_make_house()
	if fence_scene:
		_make_fence()
	if water_scene:
		_make_water()
	if rocks_scene:
		_make_rocks()
	if tree_scene:
		_make_trees()
	if food_scene:
		_make_food()

func _make_spawn_location():
	var spawn = spawn_scene.instantiate()
	spawn.initialize(ground)
	
func _make_house():
	var house = house_scene.instantiate()
	house.initialize(ground)
	add_child(house)
	
func _make_rocks():
	var rocks = rocks_scene.instantiate()
	rocks.initialize(ground, ["house"])
	add_child(rocks)
	
func _make_trees():
	var tree = tree_scene.instantiate()
	tree.initialize(ground)
	for index in range(tree.get_coverage()):
		tree = tree_scene.instantiate()
		tree.initialize(ground, ["house"])
		add_child(tree) 

func _make_fence():
	pass

func _make_water():
	var water = water_scene.instantiate()
	water.initialize(ground)
	for index in range(water.get_coverage()):
		water = water_scene.instantiate()
		water.initialize(ground, ["house"])
		add_child(water)

func _make_food():
	var food = food_scene.instantiate()
	food.initialize(ground)
	for index in range(food.get_coverage()):
		food = food_scene.instantiate()
		food.initialize(ground, ["house", "water", "rock", "tree"])
		food.eaten.connect($/root/Main/UserInterface/Accent/ScoreLabel._on_food_eaten.bind())
		food.eaten.connect($/root/Main/UserInterface/Accent/ComboLabel._on_food_eaten.bind())
		add_child(food)

func _on_food_timer_timeout() -> void:
	_make_food()
