extends SeedableArea
class_name TileOrchestrator

var tileable_areas: Array[SeedableArea]

@export var pad_tiles: int = 2
@export var random_placement: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in get_children():
		if child is SeedableArea and child.enabled:
			tileable_areas.append(child)

	if random_placement:
		tileable_areas.shuffle()

	if tileable_areas.size() > 0:
		_place_tiles()
	
	$Ground.queue_free()
	$Water.queue_free()
	#$FillerArea.queue_free()

# Calculates the square of `tilaeable_areas` 
# used to calculate the size of the grid without padding
func _get_tiles_squared():
	return ceil(sqrt(tileable_areas.size()))

# places tiles in a square configuration with $FillerArea to fill in any gaps
func _place_tiles() -> void:
	_place_tiles_squared()

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
	var tile = SeedableArea.new()
	if tile.use_ground:
		tile.add_child($Ground.duplicate())
	if tile.use_water:
		tile.add_child($Water.duplicate())

	add_child(tile)
	return tile
	
# moves the passed in tile to an offset of +z +x
func _position_tile(tile, z, x) -> void:
	var x_offset = (x * get_x()) - (get_x() )
	var z_offset = (z * get_z()) - (get_z() )
	tile.position = Vector3(x_offset, 0.0, z_offset)

func get_surface() -> Ground:
	if get_node_or_null("Ground"):
		return $Ground
	
	if get_node_or_null("Water"):
		return $Water
	
	return null

func get_x():
	return get_surface().world_x

func get_z():
	return get_surface().world_z
