@tool
extends GaeaNodeResource
class_name GaeaNodeConstant


func _get_data(output_port: GaeaNodeSlotOutput, area: AABB, generator_data: GaeaData) -> Dictionary:
	_log_data(output_port, generator_data)
	return output_port.return_value(_get_arg(&"value", area, generator_data))
