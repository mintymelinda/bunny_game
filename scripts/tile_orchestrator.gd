extends Node3D

@export var tileable_areas: Array[Node3D]
var seedable_scene = load("res://scenes/seedable_area.tscn")

@export var pad_tiles: int = 2
@export var random_placement: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in get_children():
		tileable_areas.append(child)
	
	_place_tiles_sequentially()

func _place_tiles_sequentially() -> void:
	var index = 0
	var tiles = ceil(sqrt(tileable_areas.size()))
	for z in range(tiles + pad_tiles + pad_tiles):
		for x in range(tiles + pad_tiles + pad_tiles):
			var tile
			if pad_tiles - z > 0:
				# top row
				tile = _get_blank_tile()
			elif pad_tiles - x > 0:
				# first column
				tile = _get_blank_tile()
			elif z >= tiles + pad_tiles:
				# bottom row
				tile = _get_blank_tile()
			elif x >= tiles + pad_tiles:
				# last column row
				tile = _get_blank_tile()
			elif index >= tileable_areas.size():
				# filler
				tile = _get_blank_tile()
			else:
				tile = tileable_areas[index]
				index += 1

			_position_tile(tile, z, x)

func _get_blank_tile():
	var tile = seedable_scene.instantiate()
	add_child(tile)
	return tile 

func _position_tile(tile, z, x) -> void:
	var x_offset = x * tile.ground.area.shape.size.x
	var z_offset = z * tile.ground.area.shape.size.z
	tile.position = Vector3(x_offset, 0.0, z_offset)
