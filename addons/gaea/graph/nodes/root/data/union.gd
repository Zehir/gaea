@tool
extends GaeaNodeResource


func _get_data(output_port: GaeaNodeSlotOutput, area: AABB, generator_data: GaeaData) -> Dictionary:
	_log_data(output_port, generator_data)
	
	var grids: Array[Dictionary] = []
	for param in params:
		grids.append(_get_arg(param.name, area, generator_data))

	var grid: Dictionary = {}
	if grids.is_empty():
		return grid

	for x in _get_axis_range(Axis.X, area):
		for y in _get_axis_range(Axis.Y, area):
			for z in _get_axis_range(Axis.Z, area):
				var cell: Vector3i = Vector3i(x, y, z)
				for subgrid: Dictionary in grids:
					if subgrid.get(cell) != null:
						grid.set(cell, subgrid.get(cell))

	return output_port.return_value(grid)
