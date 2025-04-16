@tool
extends GaeaNodeResource

enum Operation {
	Add,
	Substract,
	Multiply,
	Divide,
	Mod,
	Power,
	Max,
	Min,
	Snapped,
	Abs,
	Ceil,
	Clamp,
	Floor,
	Round,
	Lerp,
	Log,
	Remap,
	Sign,
	Smoothstep,
	Warp,
}


class Definition:
	var args: Array[String]
	var output: String
	var conversion: Callable
	func _init(_args: Array[String], _output: String, _conversion: Callable):
		args = _args
		output = _output
		conversion = _conversion


static var OPERATION_DEFINITIONS: Dictionary[Operation, Definition] = {
	Operation.Add: Definition.new(["X", "Y"], "x + y", func(x: float, y: float): return x + y),
	Operation.Substract: Definition.new(["X", "Y"], "x - b", func(x: float, y: float): return x - y),
	Operation.Multiply: Definition.new(["X", "Y"], "x * b", func(x: float, y: float): return x * y),
	Operation.Divide: Definition.new(["X", "Y"], "x / b", func(x: float, y: float): return 0.0 if is_zero_approx(y) else x / y),
	Operation.Mod: Definition.new(["X", "Y"], "fmod(x, y)", func(x: float, y: float): return 0.0 if is_zero_approx(y) else fmod(x, y)),
	Operation.Power: Definition.new(["Base", "Exp"], "pow(base, exp)", pow),
	Operation.Max: Definition.new(["A","B"], "maxf(a, b)", maxf),
	Operation.Min: Definition.new(["A","B"], "minf(a, b)", minf),
	Operation.Snapped: Definition.new(["X", "Step"], "snappedf(x, step)", snappedf),
	Operation.Abs: Definition.new(["X"], "absf(x)", absf),
	Operation.Ceil: Definition.new(["X"], "ceilf(x)", ceilf),
	Operation.Floor: Definition.new(["X"], "floorf(x)", floorf),
	Operation.Round: Definition.new(["X"], "roundf(x)", roundf),
	Operation.Clamp: Definition.new(["Value", "Min", "Max"], "clampf(value, min, max)", clampf),
	Operation.Lerp: Definition.new(["From", "To", "Weight"], "lerpf(from, to, weight)", lerpf),
	Operation.Log: Definition.new(["X"], "log(x)", log),
	Operation.Remap: Definition.new(
		["Value", "In start", "In stop", "Out start", "Out stop"],
		"remap(value, ...)",
		remap
	),
	Operation.Sign: Definition.new(["X"], "signf(x)", signf),
	Operation.Smoothstep: Definition.new(["From", "To", "X"], "smoothstep(from, to, x", smoothstep),
	Operation.Warp: Definition.new(["Value", "Min", "Max"], "wrapf(value, min, max", wrapf),
}


func _on_static_arg_value_changed(value: Variant, slot_index: int, arg_name: String):
	match arg_name:
		"operation":
			var definition := OPERATION_DEFINITIONS[value as Operation]
			for arg_index in definition.args.size():
				var parameter: GaeaGraphNodeParameter = node.get_child(slot_index + 1 + arg_index)
				parameter.slot_visible = true
				if parameter.has_method("set_label_text"):
					parameter.set_label_text(definition.args[arg_index])
			for arg_index in range(1 + definition.args.size(), args.size()):
				var parameter: GaeaGraphNodeParameter = node.get_child(arg_index)
				parameter.slot_visible = false
			var output_node: Node = node.get_child(-1)
			output_node.right_label = "= %s" % definition.output


func get_data(_passed_data:Array[Dictionary], output_port: int, _area: AABB, generator_data: GaeaData) -> Dictionary:
	log_data(output_port, generator_data)
	var operation: Operation = get_arg("operation", generator_data)
	return {"value": _get_new_value(operation, generator_data)}


func _get_new_value(operation: Operation, generator_data: GaeaData) -> float:
	if OPERATION_DEFINITIONS.has(operation):
		var definition = OPERATION_DEFINITIONS[operation]
		var params: Array[float] = []
		for arg_index in definition.args.size():
			# Offset by one because the first arg in operation
			params.append(float(get_arg(args[arg_index + 1].name, generator_data)))
		return OPERATION_DEFINITIONS[operation].conversion.callv(params)
	push_error("Operation not found %s" % operation)
	return 0.0
