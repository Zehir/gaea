@tool
extends GaeaNodeResource

enum Operation {
	Add,
	Substract,
	Multiply,
	Divide,
	Remainder,
	Power,
	Max,
	Min,
	ATan2,
	Snapped,
}


func get_data(_passed_data:Array[Dictionary], output_port: int, _area: AABB, generator_data: GaeaData) -> Dictionary:
	log_data(output_port, generator_data)

	var a: float = get_arg("a", generator_data)
	var b: float = get_arg("b", generator_data)
	var operation: Operation = get_arg("operation", generator_data)

	return {"value": _get_new_value(a, b, operation)}


func _get_new_value(a: float, b: float, operation: Operation) -> float:
	if typeof(a) != typeof(b):
		return a

	match operation:
		Operation.Add: return a + b
		Operation.Substract: return a - b
		Operation.Multiply: return a * b
		Operation.Divide: return 0.0 if is_zero_approx(b) else a / b
		Operation.Remainder: return 0.0 if is_zero_approx(b) else fmod(a, b)
		Operation.Power: return pow(a, b)
		Operation.Max: return maxf(a, b)
		Operation.Min: return minf(a, b)
		Operation.ATan2: return atan2(a, b)
		Operation.Snapped: return snappedf(a, b)
	return a


func _get_required_input_ports() -> Array[int]:
	return [0, 1]
