@tool
class_name GridmapMaterial
extends GaeaMaterial
## Resource used to tell the [GridmapGaeaRenderer] which tile from a [TileMap] to place.


## The index of the item in the [MeshLibrary].
@export var item_idx: int = 0
## The orientation of the item. For valid orientation values, see [member GridMap.get_orthogonal_index_from_basis()].
@export var orientation: int = 0
