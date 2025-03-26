@tool
extends GaeaNodeResource


func get_data(output_port: int, area: AABB, generator_data: GaeaData) -> Dictionary[Vector3i, float]:
	var connected_data_idx: int = get_connected_resource_idx(0)
	if connected_data_idx == -1:
		return {}

	var data_input_resource: GaeaNodeResource = generator_data.resources.get(connected_data_idx)
	if not is_instance_valid(data_input_resource):
		return {}

	var passed_data: Dictionary = data_input_resource.get_data(
		get_connected_port_to(0),
		area, generator_data
	)

	var new_data: Dictionary[Vector3i, float] = {}
	for cell: Vector3i in passed_data:
		if _passes_filter(passed_data, cell, generator_data):
			new_data.set(cell, passed_data.get(cell))

	return new_data


func _passes_filter(passed_data: Dictionary, cell: Vector3i, generator_data: GaeaData) -> bool:
	return true
