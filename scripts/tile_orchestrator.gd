extends Node3D

@export var tileable_areas: Array[Node3D]
var seedable_scene = load("res://scenes/seedable_area.tscn")

@export var num_z_tiles: int = 5
@export var num_x_tiles: int = 5

var tiles_placed: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in get_children():
		tileable_areas.append(child)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not tiles_placed:
		_place_tiles_sequentially()

func _place_tiles_sequentially() -> void:
	var index = 0
	for z in range(num_z_tiles):
		for x in range(num_x_tiles):
			var tile
			if index >= tileable_areas.size():
				tile = seedable_scene.instantiate()
				add_child(tile)
			else:
				tile = tileable_areas[index]
				index += 1

			tile.position = Vector3(x * tile.ground_area.shape.size.x, 0.0, z * tile.ground_area.shape.size.x)

	tiles_placed = true
