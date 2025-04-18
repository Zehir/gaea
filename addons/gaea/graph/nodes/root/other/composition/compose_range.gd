@tool
extends GaeaNodeResource


func get_data(output_port: GaeaNodeSlotOutput, area: AABB, generator_data: GaeaData) -> Dictionary:
	log_data(output_port, generator_data)
	return {
		"value": {
			"min": get_arg("min", area, generator_data),
			"max": get_arg("max", area, generator_data),
		}
	}
