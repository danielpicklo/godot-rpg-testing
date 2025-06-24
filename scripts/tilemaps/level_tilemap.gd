class_name LevelTileMap extends TileMapLayer

@onready var fences: TileMapLayer = $"../fences"

func _ready():
	LevelManager.ChangeTileMapBounds(GetTileMapBounds())
	pass

func _use_tile_data_runtime_update(coords: Vector2i) -> bool:
	if coords in fences.get_used_cells_by_id(3):
		return true
	
	return false

func _tile_data_runtime_update(coords: Vector2i, tile_data: TileData) -> void:
	if coords in fences.get_used_cells_by_id(3):
		tile_data.set_navigation_polygon(0, null)

# Determine boundary of the tilemaps
func GetTileMapBounds() -> Array[Vector2]:
	var bounds : Array[Vector2] = []
	bounds.append(
		Vector2(get_used_rect().position * rendering_quadrant_size)
	)
	
	bounds.append(
		Vector2(get_used_rect().end  * rendering_quadrant_size)
	)
	
	return bounds
