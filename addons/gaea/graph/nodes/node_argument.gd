@tool
## @deprecated
class_name GaeaNodeArgument
extends Resource


@export var type: GaeaValue.Type:
	set(value):
		type = value
		notify_property_list_changed()
@export var name: StringName
@export_storage var default_value: Variant : get = get_default_value
@export var hint: Dictionary[String, Variant]
@export_group("Slots")
@export var disable_input_slot: bool = false
@export var add_output_slot: bool = false

var value: Variant


func get_arg_node(_graph_node: GaeaGraphNode, _idx: int) -> GaeaGraphNodeParameter:
	return null
	#var scene: PackedScene = get_scene_from_type(type)
	#if not is_instance_valid(scene):
	#	return null

	#var node: GaeaGraphNodeParameter = scene.instantiate()
	#node.initialize(_graph_node, _idx)
	#if disable_input_slot:
	#	node.add_input_slot = false
	#node.add_output_slot = add_output_slot
	#node.resource = self

	#return node


func get_arg_name() -> StringName:
	return name


func get_default_value() -> Variant:
	if default_value != null:
		return default_value

	return null
