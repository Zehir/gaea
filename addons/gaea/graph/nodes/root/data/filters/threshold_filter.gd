@tool
extends "res://addons/gaea/graph/nodes/root/data/filters/filter.gd"


func _passes_filter(passed_data: Dictionary[Vector3i, float], cell: Vector3i, generator_data: GaeaData) -> bool:
	var range: Dictionary = get_arg("range", generator_data)
	var value = passed_data.get(cell)
	return value >= range.get("min", 0.0) and value <= range.get("max", 0.0)
