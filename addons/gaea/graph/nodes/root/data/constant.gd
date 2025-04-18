@tool
extends GaeaNodeResource


func get_data(_output_port: GaeaNodeSlotOutput, _area: AABB, _generator_data: GaeaData) -> Dictionary:
	log_data(_output_port, _generator_data)
	return {
		"value": get_arg("value", _area, null)
	}
