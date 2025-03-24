@tool
extends GaeaNodeResource


func get_data(output_port: int, area: AABB, generator_data: GaeaData) -> Dictionary:
	var data_input_resource: GaeaNodeResource = generator_data.resources.get(get_connected_resource_idx(0))
	if not is_instance_valid(data_input_resource):
		return {}

	var original_grid: Dictionary = data_input_resource.get_data(
		get_connected_port_to(0),
		area, generator_data
	)
	var material: GaeaMaterial = null

	var grid: Dictionary = {}

	for x in get_axis_range(Axis.X, area):
		for y in get_axis_range(Axis.Y, area):
			for z in get_axis_range(Axis.Z, area):
				var cell: Vector3i = Vector3i(x, y, z)
				if original_grid.get(cell) == null:
					grid.set(cell, 1.0)

	return grid
