@tool
class_name TileMapGaeaRenderer
extends GaeaRenderer


@export var tile_map_layers: Array[TileMapLayer] = []


func render(grid: GaeaGrid) -> void:
	var terrains: Dictionary[TileMapMaterial, Array]

	for layer_idx in grid.get_layers_count():
		for cell in grid.get_layer(layer_idx):
			var value = grid.get_layer(layer_idx)[cell]
			if value is TileMapMaterial:
				if value.type == TileMapMaterial.Type.SINGLE_CELL:
					if tile_map_layers.size() <= layer_idx:
						continue
					tile_map_layers[layer_idx].set_cell(Vector2i(cell.x, cell.y), value.source_id, value.atlas_coord, value.alternative_tile)
				elif value.type == TileMapMaterial.Type.TERRAIN:
					terrains.get_or_add(value, []).append(Vector2(cell.x, cell.y))

		for material: TileMapMaterial in terrains:
			tile_map_layers[layer_idx].set_cells_terrain_connect(
				terrains.get(material), material.terrain_set, material.terrain
			)



func _on_area_erased(area: AABB) -> void:
	for x in range(area.position.x, area.end.x):
		for y in range(area.position.y, area.end.y):
			for layer in tile_map_layers:
				layer.erase_cell(Vector2i(x, y))


func reset() -> void:
	for tile_map_layer in tile_map_layers:
		tile_map_layer.clear()
