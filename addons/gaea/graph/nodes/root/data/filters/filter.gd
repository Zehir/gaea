@tool
extends GaeaNodeResource

func _get_required_params() -> Array[StringName]:
	return [&"data"]


func get_data(output_port: GaeaNodeSlotOutput, area: AABB, generator_data: GaeaData) -> Dictionary:
	log_data(output_port, generator_data)

	seed(generator_data.generator.seed + salt)

	var input_data: Dictionary[Vector3i, float] = get_arg(&"data", area, generator_data)
	var new_data: Dictionary = {}
	for cell: Vector3i in input_data:
		if _passes_filter(input_data, cell, area, generator_data):
			new_data.set(cell, input_data.get(cell))

	return new_data


@warning_ignore("unused_parameter")
func _passes_filter(input_data: Dictionary, cell: Vector3i, area: AABB, generator_data: GaeaData) -> bool:
	return true
