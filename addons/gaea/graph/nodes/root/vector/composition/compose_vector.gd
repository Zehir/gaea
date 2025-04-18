@tool
extends GaeaNodeResource


@export_enum("Vector2", "Vector3") var type: int = 0


func get_data(output_port: GaeaNodeSlotOutput, area: AABB, generator_data: GaeaData) -> Dictionary:
	log_data(output_port, generator_data)
	if type == 0:
		return {
			"value": Vector2(
				get_arg("x", area, generator_data),
				get_arg("y", area, generator_data)
			)
		}
	elif type == 1:
		return {
			"value": Vector3(
				get_arg("x", area, generator_data),
				get_arg("y", area, generator_data),
				get_arg("z", area, generator_data)
			)
		}
	return {}
