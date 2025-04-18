@tool
class_name GaeaNodeSlotParam extends GaeaNodeSlot

enum Mode {
	SINGLE,
	ARRAY,
}


enum Type {
	FLOAT,
	INT,
	VECTOR2,
	VARIABLE_NAME, ## Used for VariableNodes.
	RANGE, ## Dictionary holding 2 keys: min and max.
	BITMASK, ## Int representing a bitmask.
	CATEGORY, ## For visual separation, doesn't get saved.
	BITMASK_EXCLUSIVE, ## Same as bitmask but only one bit can be active at once.
	FLAGS, ## Same interface as bitmask, but returns an Array of flags.
	BOOLEAN,
	VECTOR3,
	NEIGHBOR,
	RULES
}

@export var name: StringName = &""
@export var type: Type = Type.FLOAT:
	set(value):
		type = value
		notify_property_list_changed()
@export_storage var default_value: Variant = null
@export var mode: Mode = Mode.SINGLE
@export var hint: Dictionary[String, Variant]



func _property_can_revert(property: StringName) -> bool:
	if property == &"default_value":
		return true
	return false


func _property_get_revert(property: StringName) -> Variant:
	if property == &"default_value":
		match type:
			Type.VARIABLE_NAME:
				return ""
			Type.FLOAT:
				return 0.0
			Type.INT, Type.BITMASK, Type.BITMASK_EXCLUSIVE:
				return 0
			Type.VECTOR2:
				return Vector2.ZERO
			Type.RANGE:
				return {"min": 0.0, "max": 0.0}
			Type.BOOLEAN:
				return false
			Type.NEIGHBOR:
				return [] as Array[Vector2i]
			Type.FLAGS:
				return [] as Array[int]
			Type.VECTOR3:
				return Vector3.ZERO
			Type.RULES:
				return {}
	return null


func _validate_property(property: Dictionary) -> void:
	if property.name == "default_value":
		match type:
			Type.FLOAT:
				property.type = TYPE_FLOAT
				property.usage = PROPERTY_USAGE_EDITOR | PROPERTY_USAGE_STORAGE
			Type.INT:
				property.type = TYPE_INT
				property.usage = PROPERTY_USAGE_EDITOR | PROPERTY_USAGE_STORAGE
			Type.VECTOR2:
				property.type = TYPE_VECTOR2
				property.usage = PROPERTY_USAGE_EDITOR | PROPERTY_USAGE_STORAGE
			Type.RANGE:
				property.type = TYPE_DICTIONARY
				property.usage = PROPERTY_USAGE_EDITOR | PROPERTY_USAGE_STORAGE
			Type.BITMASK, Type.BITMASK_EXCLUSIVE:
				property.type = TYPE_INT
				property.usage = PROPERTY_USAGE_EDITOR | PROPERTY_USAGE_STORAGE
				property.hint = PROPERTY_HINT_LAYERS_2D_PHYSICS
			Type.BOOLEAN:
				property.type = TYPE_BOOL
				property.usage = PROPERTY_USAGE_EDITOR | PROPERTY_USAGE_STORAGE
			Type.FLAGS:
				property.type = TYPE_ARRAY
				property.hint = PROPERTY_HINT_TYPE_STRING
				property.usage = PROPERTY_USAGE_EDITOR | PROPERTY_USAGE_STORAGE
				property.hint_string = "%d:" % [TYPE_INT]
			Type.VECTOR3:
				property.type = TYPE_VECTOR3
				property.usage = PROPERTY_USAGE_EDITOR | PROPERTY_USAGE_STORAGE
			Type.NEIGHBOR:
				property.type = TYPE_ARRAY
				property.hint = PROPERTY_HINT_TYPE_STRING
				property.usage = PROPERTY_USAGE_EDITOR | PROPERTY_USAGE_STORAGE
				property.hint_string = "%d:" % [TYPE_VECTOR2I]

	if property.name == "hint" and type == Type.CATEGORY:
		property.usage = PROPERTY_USAGE_NONE


static func has_input(of_type: Type) -> bool:
	return of_type not in [
		Type.CATEGORY, Type.VARIABLE_NAME, Type.BITMASK,
		Type.BITMASK_EXCLUSIVE, Type.FLAGS, Type.RULES,
		Type.NEIGHBOR
	]



static func get_scene_from_type(for_type: Type) -> PackedScene:
	match for_type:
		Type.FLOAT, Type.INT:
			return preload("uid://dp7blnx7abb5e")
		Type.VECTOR2:
			return preload("uid://rlocedi6g62i")
		Type.VARIABLE_NAME:
			return preload("uid://bn8i1l4q13pdw")
		Type.RANGE:
			return preload("uid://dy3oumbnydlmp")
		Type.BITMASK, Type.BITMASK_EXCLUSIVE, Type.FLAGS:
			return preload("uid://chdg8ey4ln8d1")
		Type.CATEGORY:
			return preload("uid://x6n8ylnxoyno")
		Type.BOOLEAN:
			return preload("uid://byaonbbfa2bx8")
		Type.VECTOR3:
			return preload("uid://mlwupvg8a886")
		Type.NEIGHBOR:
			return preload("uid://d11yc7l6sneof")
		Type.RULES:
			return preload("uid://dy4n2a5hkaxsb")
	return null


static func get_display_icon_for_type(for_type: Type) -> Texture2D:
	if for_type == Type.FLOAT:
		return preload("uid://baw7ye0h4xdcx")
	if for_type == Type.INT:
		return preload("uid://bilsfh3nrbhkl")
	return GaeaNodeSlot.get_display_icon(get_slot_type_equivalent(for_type))




static func get_slot_type_equivalent(for_type: Type) -> SlotType:
	match for_type:
		Type.FLOAT, Type.INT:
			return SlotType.NUMBER
		Type.VECTOR2:
			return SlotType.VECTOR2
		Type.VECTOR3:
			return SlotType.VECTOR3
		Type.BOOLEAN:
			return SlotType.BOOL
		Type.RANGE:
			return SlotType.RANGE
		_:
			return SlotType.NULL





#region Data casting methods
## Return the castable types, the inner array is a tuple with [from, to] SlotType
static func get_cast_list() -> Array[Array]:
	var casts: Array[Array] = []

	casts.append([SlotType.NUMBER, SlotType.VECTOR2])
	casts.append([SlotType.NUMBER, SlotType.VECTOR3])
	casts.append([SlotType.NUMBER, SlotType.BOOL])

	casts.append([SlotType.RANGE, SlotType.VECTOR2])

	casts.append([SlotType.VECTOR2, SlotType.RANGE])
	casts.append([SlotType.VECTOR2, SlotType.VECTOR3])
	casts.append([SlotType.VECTOR2, SlotType.NUMBER])
	casts.append([SlotType.VECTOR3, SlotType.VECTOR2])
	casts.append([SlotType.VECTOR3, SlotType.NUMBER])

	casts.append([SlotType.BOOL, SlotType.NUMBER])
	casts.append([SlotType.BOOL, SlotType.VECTOR2])
	casts.append([SlotType.BOOL, SlotType.VECTOR3])

	return casts

static func cast_value(from_type: SlotType, to_type: SlotType, value: Variant) -> Variant:
	match [from_type, to_type]:
		#region Range -> Any
		[SlotType.RANGE, SlotType.VECTOR2]:
			return Vector2(
				value.get("min"), value.get("max")
			)
		#endregion

		#region Number -> Any
		[SlotType.NUMBER, SlotType.VECTOR2]:
			return Vector2(
				value, value
			)
		[SlotType.NUMBER, SlotType.VECTOR3]:
			return Vector3(
				value, value, value
			)
		[SlotType.NUMBER, SlotType.BOOL]:
			return bool(value)
		#endregion

		#region Vector -> Any
		[SlotType.VECTOR2, SlotType.RANGE]:
			return {
				"min": value.x, "max": value.y
			}
		[SlotType.VECTOR2, SlotType.VECTOR3]:
			return Vector3(
				value.x, value.y, 0.0
			)
		[SlotType.VECTOR3, SlotType.VECTOR2]:
			return Vector2(
				value.x, value.y
			)
		[SlotType.VECTOR2, SlotType.NUMBER],\
		[SlotType.VECTOR3, SlotType.NUMBER]:
			return value.x
		#endregion

		#region Boolean -> Any
		[SlotType.BOOL, SlotType.NUMBER]:
			return float(value)
		[SlotType.BOOL, SlotType.VECTOR2]:
			return Vector2(float(value), float(value))
		[SlotType.BOOL, SlotType.VECTOR3]:
			return Vector3(float(value), float(value), float(value))
		#endregion

	printerr("Could not get data from previous node, missing cast method from %s to %s" % [
		SlotType.find_key(from_type),
		SlotType.find_key(to_type),
	])
	return {}
#endregion
