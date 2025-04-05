@tool
extends "res://addons/gaea/graph/nodes/operation.gd"



func get_data(output_port: int, area: AABB, generator_data: GaeaData) -> Dictionary[Vector3i, float]:
	var a_data_connected_idx: int = get_connected_resource_idx(0)
	if a_data_connected_idx == -1:
		return {}
	var a_data_input_resource: GaeaNodeResource = generator_data.resources.get(a_data_connected_idx)
	if not is_instance_valid(a_data_input_resource):
		return {}

	var a_input: Dictionary = a_data_input_resource.get_data(
		get_connected_port_to(0),
		area, generator_data
	)

	var b_data_connected_idx: int = get_connected_resource_idx(1)
	if b_data_connected_idx == -1:
		return {}
	var b_data_input_resource: GaeaNodeResource = generator_data.resources.get(b_data_connected_idx)
	if not is_instance_valid(b_data_input_resource):
		return {}

	var b_input: Dictionary = b_data_input_resource.get_data(
		get_connected_port_to(1),
		area, generator_data
	)

	var new_grid: Dictionary[Vector3i, float]
	for cell: Vector3i in a_input.keys() + b_input.keys():
		new_grid.set(cell, _get_new_value(a_input.get(cell), b_input.get(cell)))

	return new_grid
