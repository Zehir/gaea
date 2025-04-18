@tool
extends GaeaNodeResource


func get_data(_passed_data:Array[Dictionary], _output_port: int, _area: AABB, _generator_data: GaeaData) -> Dictionary:
	log_data(_output_port, _generator_data)
	return {
		"value": get_arg("value", null)
	}


func get_type() -> GaeaNodeSlot.SlotType:
	return GaeaNodeSlotParam.get_slot_type_equivalent(params.front().type)


func get_icon() -> Texture2D:
	var for_type: GaeaNodeSlotParam.Type = params.front().type
	return GaeaNodeSlotParam.get_display_icon_for_type(for_type)
