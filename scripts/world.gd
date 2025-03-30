extends Node

@export var fence_scene: PackedScene
@export var food_scene: PackedScene
@export var ground_scene: PackedScene
@export var house_scene: PackedScene
@export var rocks_scene: PackedScene
@export var tree_scene: PackedScene
@export var water_scene: PackedScene

var ground

func initialize(x, z, y):
	ground = ground_scene.instantiate()
	ground.initizalize(x, z, y)
	
	_seed_planet()
	add_child(ground)
	
	# $/root/Main/UserInterface/Retry.hide()

func _seed_planet() -> void:
	_make_house()
	_make_fence()
	_make_water()
	_make_rocks()
	_make_trees()
	_make_food()

func _make_house():
	var house = house_scene.instantiate()
	house.initialize(ground)
	ground.add(house)
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
		ground.add(tree)
		add_child(tree) 

func _make_fence():
	pass

func _make_water():
	var water = water_scene.instantiate()
	water.initialize(ground)
	for 	index in range(water.get_coverage()):
		water = water_scene.instantiate()
		water.initialize(ground, ["house"])
		ground.add(water)
		add_child(water)

func _make_food():
	var food = food_scene.instantiate()
	food.initialize(ground)
	for 	index in range(food.get_coverage()):
		food = food_scene.instantiate()
		food.initialize(ground, ["house", "water", "rock", "tree"])
		#food.eaten.connect($/root/Main/UserInterface/ScoreLabel._on_food_eaten.bind())
		#food.eaten.connect($/root/Main/UserInterface/ComboLabel._on_food_eaten.bind())
		ground.add(food)
		add_child(food)

func _on_food_timer_timeout() -> void:
	_make_food()
