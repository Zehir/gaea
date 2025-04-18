class_name GaeaNodeSlotParam extends GaeaNodeSlot

enum Mode {
	SINGLE,
	ARRAY,
}

@export var mode: Mode = Mode.SINGLE
@export var default_value: Variant = null
@export var hint: Dictionary[String, Variant]


#region Data casting methods
## Return the castable types, the inner array is a tuple with [from, to] SlotTypes
static func get_cast_list() -> Array[Array]:
	var casts: Array[Array] = []

	casts.append([SlotTypes.NUMBER, SlotTypes.VECTOR2])
	casts.append([SlotTypes.NUMBER, SlotTypes.VECTOR3])
	casts.append([SlotTypes.NUMBER, SlotTypes.BOOL])

	casts.append([SlotTypes.RANGE, SlotTypes.VECTOR2])

	casts.append([SlotTypes.VECTOR2, SlotTypes.RANGE])
	casts.append([SlotTypes.VECTOR2, SlotTypes.VECTOR3])
	casts.append([SlotTypes.VECTOR2, SlotTypes.NUMBER])
	casts.append([SlotTypes.VECTOR3, SlotTypes.VECTOR2])
	casts.append([SlotTypes.VECTOR3, SlotTypes.NUMBER])

	casts.append([SlotTypes.BOOL, SlotTypes.NUMBER])
	casts.append([SlotTypes.BOOL, SlotTypes.VECTOR2])
	casts.append([SlotTypes.BOOL, SlotTypes.VECTOR3])

	return casts

static func cast_value(from_type: SlotTypes, to_type: SlotTypes, value: Variant) -> Variant:
	match [from_type, to_type]:
		#region Range -> Any
		[SlotTypes.RANGE, SlotTypes.VECTOR2]:
			return Vector2(
				value.get("min"), value.get("max")
			)
		#endregion

		#region Number -> Any
		[SlotTypes.NUMBER, SlotTypes.VECTOR2]:
			return Vector2(
				value, value
			)
		[SlotTypes.NUMBER, SlotTypes.VECTOR3]:
			return Vector3(
				value, value, value
			)
		[SlotTypes.NUMBER, SlotTypes.BOOL]:
			return bool(value)
		#endregion

		#region Vector -> Any
		[SlotTypes.VECTOR2, SlotTypes.RANGE]:
			return {
				"min": value.x, "max": value.y
			}
		[SlotTypes.VECTOR2, SlotTypes.VECTOR3]:
			return Vector3(
				value.x, value.y, 0.0
			)
		[SlotTypes.VECTOR3, SlotTypes.VECTOR2]:
			return Vector2(
				value.x, value.y
			)
		[SlotTypes.VECTOR2, SlotTypes.NUMBER],\
		[SlotTypes.VECTOR3, SlotTypes.NUMBER]:
			return value.x
		#endregion

		#region Boolean -> Any
		[SlotTypes.BOOL, SlotTypes.NUMBER]:
			return float(value)
		[SlotTypes.BOOL, SlotTypes.VECTOR2]:
			return Vector2(float(value), float(value))
		[SlotTypes.BOOL, SlotTypes.VECTOR3]:
			return Vector3(float(value), float(value), float(value))
		#endregion

	printerr("Could not get data from previous node, missing cast method from %s to %s" % [
		SlotTypes.find_key(from_type),
		SlotTypes.find_key(to_type),
	])
	return {}
#endregion
