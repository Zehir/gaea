@tool
extends GaeaNodeResource


func get_data(output_port: GaeaNodeSlotOutput, area: AABB, generator_data: GaeaData) -> Dictionary:
	log_data(output_port, generator_data)
	var vector = get_arg("vector", area, generator_data)
	match output_port.name:
		&"x":
			return {"value": vector.x}
		&"y":
			return {"value": vector.y}
		&"z":
			return {"value": vector.z}
	return {}
