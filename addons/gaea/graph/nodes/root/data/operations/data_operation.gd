@tool
extends "res://addons/gaea/graph/nodes/operation.gd"



func get_data(output_port: int, area: AABB, generator_data: GaeaData) -> Dictionary[Vector3i, float]:
	var data_connected_idx: int = get_connected_resource_idx(0)
	if data_connected_idx == -1:
		return {}
	var data_input_resource: GaeaNodeResource = generator_data.resources.get(data_connected_idx)
	if not is_instance_valid(data_input_resource):
		return {}

	var passed_data: Dictionary = data_input_resource.get_data(
		get_connected_port_to(0),
		area, generator_data
	)

	var new_grid: Dictionary[Vector3i, float]
	for cell in passed_data:
		new_grid.set(cell, _get_new_value(passed_data.get(cell), get_arg("value", generator_data)))

	return new_grid
