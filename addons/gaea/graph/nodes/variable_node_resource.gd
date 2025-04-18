@tool
extends GaeaNodeResource
class_name GaeaVariableNodeResource


@export var type: Variant.Type
@export var hint: PropertyHint
@export var hint_string: String
@export var output_type: GaeaValue.Type:
	set(new_value):
		output_type = new_value
		var output = GaeaNodeSlotOutput.new()
		output.name = "value"
		output.type = new_value
		outputs = [output]
		notify_property_list_changed()


func get_data(output_port: GaeaNodeSlotOutput, area: AABB, generator_data: GaeaData) -> Dictionary:
	log_data(output_port, generator_data)
	return generator_data.parameters.get(get_arg("name", area, null))


func get_scene() -> PackedScene:
	return preload("uid://bodjhgqp1bpui")


func get_type() -> GaeaValue.Type:
	return GaeaValue.from_variant_type(type, hint_string)
