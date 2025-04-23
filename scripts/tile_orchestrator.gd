extends SeedableArea
class_name TileOrchestrator

var tileable_areas: Array[Ground]
@export var random = false

enum placement_type {
	squared,
	z_fill,
	x_fill
}

@export var pad_tiles: int = 2
@export var placement: placement_type = placement_type.squared

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in get_children():
		if child is Ground:
			tileable_areas.append(child)

	if tileable_areas.size() < 1:
		return

	_place_tiles()

func _place_tiles() -> void:
	if random:
		tileable_areas.shuffle()

	match placement:
		placement_type.squared:
			_place_tiles_squared()
		placement_type.z_fill:
			_place_tiles_z_fill()
		placement_type.x_fill:
			_place_tiles_x_fill()

func _place_tiles_x_fill():
	var index = 0
	var tiles = tileable_areas.size()
	for x in range(tiles + pad_tiles + pad_tiles):
		for z in range(tiles + pad_tiles + pad_tiles):
			var tile
			if pad_tiles - z > 0:
				# top row
				tile = _get_blank_tile()
			elif z >= tiles + pad_tiles:
				# bottom row
				tile = _get_blank_tile()
			elif z == 0:
				tile = tileable_areas[index]
			else:
				tile = tileable_areas[index].duplicate()
			
			if not tile.is_inside_tree():
				add_child(tile)

			_position_tile(tile, z, x)

			if tile is TileOrchestrator and tile.enabled:
				tile._place_tiles()

		index += 1

func _place_tiles_z_fill():
	var index = 0
	var tiles = tileable_areas.size()
	for z in range(tiles + pad_tiles + pad_tiles):
		var tile
		for x in range(tiles + pad_tiles + pad_tiles):
			if pad_tiles - x > 0:
				# first column
				tile = _get_blank_tile()
			elif x >= tiles + pad_tiles:
				# last column row
				tile = _get_blank_tile()
			elif x == 0:
				tile = tileable_areas[index]
			else:
				tile = tileable_areas[index].duplicate()

			if not tile.is_inside_tree():
				add_child(tile)

			_position_tile(tile, z, x)

			if tile is TileOrchestrator and tile.enabled:
				tile._place_tiles()
			
			#tile = tileable_areas[index].duplicate()
		# tile.queue_free()
		index += 1

# Calculates the square of `tilaeable_areas` 
# used to calculate the size of the grid without padding
func _get_tiles_squared():
	return ceil(sqrt(tileable_areas.size()))

# places tiles in a square configuration with $FillerArea to fill in any gaps
func _place_tiles_squared():
	var index = 0
	var tiles = _get_tiles_squared()
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

			if tile is TileOrchestrator and tile.enabled:
				tile._place_tiles()

# Creates a duplicate of $FillerArea
func _get_blank_tile():
	var tile = Ground.new()
	tile.set_x(get_max_x())
	tile.set_y(get_max_y())
	tile.set_z(get_max_z())

	add_child(tile)
	return tile
	
# moves the passed in tile to an offset of +z +x
func _position_tile(tile, z, x) -> void:
	var x_offset = (x * get_max_x()) - (get_max_x() )
	var z_offset = (z * get_max_z()) - (get_max_z() )
	tile.position = Vector3(x_offset, 0.0, z_offset)

func get_max_x():
	var x = 0
	for ground in tileable_areas:
		x = maxf(ground.get_x(), x)
	return x

func get_max_y():
	var y = 0
	for ground in tileable_areas:
		y = max(ground.get_y(), y)
	return y

func get_max_z():
	var z = 0
	for ground in tileable_areas:
		z = max(ground.get_z(), z)
	return z
