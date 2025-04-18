@tool
class_name GaeaNodeSlot extends Resource

const SLOT_SCENE = preload("uid://cqpby5jyv71l0")

enum ParamType {
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

enum SlotTypes {
	DATA,
	MAP,
	MATERIAL,
	VECTOR2,
	NUMBER,
	RANGE,
	BOOL,
	VECTOR3,
	GRADIENT,
	NULL = -1
}


@export var type: ParamType
@export var name: StringName


func _get_label() -> String:
	return ""


static func get_icon_for_slot_type(slot_type: SlotTypes) -> Texture2D:
	match slot_type:
		SlotTypes.BOOL:
			return preload("uid://0l53mu4blspj")
		SlotTypes.DATA:
			return preload("uid://dkccxw7yq1mth")
		SlotTypes.MAP:
			return preload("uid://c2i5wqidu1r1o")
		SlotTypes.MATERIAL:
			return preload("uid://b0vqox8bodse")
		SlotTypes.VECTOR2:
			return preload("uid://c8uvy6c2syjk5")
		SlotTypes.NUMBER:
			return preload("uid://by6s78k1thpy2")
		SlotTypes.RANGE:
			return preload("uid://wx4ccwofr8yy")
		SlotTypes.VECTOR3:
			return preload("uid://bkknri7u8ghs4")
	return null
