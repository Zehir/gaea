@tool
extends GaeaNodeResource


func get_data(_passed_data:Array[Dictionary], _output_port: int, _area: AABB, generator_data: GaeaData) -> Dictionary:
	log_data(_output_port, generator_data)

	if not is_instance_valid(generator_data.generator):
		return {"value": Vector3.ZERO}
	return {
		"value": Vector3(generator_data.generator.world_size)
	}
