@tool

extends GaeaGraphNode


func on_added() -> void:
	for child in get_children():
		if child is GaeaGraphNodeParameter and (child as GaeaGraphNodeParameter).resource.get_arg_name() == "operation":
			_on_param_value_changed(
				(child as GaeaGraphNodeParameter).get_param_value(),
				(child as GaeaGraphNodeParameter),
				"operation"
			)


func _on_param_value_changed(value: Variant, node: GaeaGraphNodeParameter, param_name: String) -> void:
	match param_name:
		"operation":
			var definition = resource.OPERATION_DEFINITIONS[value]
			for arg_index in definition.args.size():
				var parameter: GaeaGraphNodeParameter = get_child(node.get_index() + 1 + arg_index)
				parameter.slot_visible = true
				if parameter.has_method("set_label_text"):
					parameter.set_label_text(definition.args[arg_index])
			for arg_index in range(1 + definition.args.size(), resource.args.size()):
				var parameter: GaeaGraphNodeParameter = get_child(arg_index)
				parameter.slot_visible = false
			var output_node: Node = get_child(-1)
			output_node.right_label = "= %s" % definition.output

	super(value, node, param_name)
