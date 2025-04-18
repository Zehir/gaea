@tool
extends GaeaNodeResource
class_name GaeaVariableNodeResource


@export var type: Variant.Type
@export var hint: PropertyHint
@export var hint_string: String
@export var output_type: GaeaTypes.Values:
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


func get_godot_type_equivalent() -> GaeaNodeSlotParam.Type:
	match type:
		TYPE_INT:
			return GaeaNodeSlotParam.Type.INT
		TYPE_FLOAT:
			return GaeaNodeSlotParam.Type.FLOAT
		TYPE_VECTOR2, TYPE_VECTOR2I:
			return GaeaNodeSlotParam.Type.VECTOR2
		TYPE_BOOL:
			return GaeaNodeSlotParam.Type.BOOLEAN
		TYPE_OBJECT:
			if hint_string == "GaeaMaterial":
				return GaeaNodeSlotParam.Type.MATERIAL
			elif hint_string == "GaeaMaterialGradient":
				return GaeaNodeSlotParam.Type.GRADIENT
		TYPE_VECTOR3, TYPE_VECTOR3I:
			return GaeaNodeSlotParam.Type.VECTOR3
	return GaeaNodeSlotParam.Type.NULL



func get_type() -> GaeaNodeSlot.SlotType:
	return GaeaNodeSlotParam.get_slot_type_equivalent(get_godot_type_equivalent())

func get_icon() -> Texture2D:
	match type:
		TYPE_FLOAT:
			return preload("../../assets/types/float.svg")
		TYPE_INT:
			return preload("../../assets/types/int.svg")
		TYPE_VECTOR2:
			return preload("../../assets/types/vec2.svg")
		TYPE_VECTOR2I:
			return preload("../../assets/types/vec2i.svg")
		TYPE_BOOL:
			return preload("../../assets/types/bool.svg")
		TYPE_OBJECT:
			if hint_string == "GaeaMaterial":
				return preload("../../assets/types/material.svg")
			elif hint_string == "GaeaMaterialGradient":
				return preload("../../assets/types/material_gradient.svg")
		TYPE_VECTOR3:
			return preload("../../assets/types/vec3.svg")
		TYPE_VECTOR3I:
			return preload("../../assets/types/vec3i.svg")
	return null
