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



static func get_color_from_type(type: SlotTypes) -> Color:
	match type:
		SlotTypes.DATA:
			return Color("f0f8ff") # WHITE
		SlotTypes.MAP:
			return Color("27ae60") # GREEN
		SlotTypes.MATERIAL:
			return Color("eb2f06") # RED
		SlotTypes.VECTOR2:
			return Color("00bfff") # LIGHT BLUE
		SlotTypes.VECTOR3:
			return Color("8e44ad") # MAGENTA
		SlotTypes.NUMBER:
			return Color("a0a0a0") # GRAY
		SlotTypes.RANGE:
			return Color("f04c7f") # PINK
		SlotTypes.BOOL:
			return Color("ffdd59") # YELLOW
		SlotTypes.GRADIENT:
			return Color("4834d4") # BLURPLE
		#SlotTypes.TEXTURE: # Reserved Orange for later use.
		#	return Color("e67e22")
	return Color.WHITE

## Get icon for menu
static func get_readable_icon_from_type(slot_type: SlotTypes) -> Texture2D:
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

## Get icon for the GraphNode slot
static func get_connection_icon_from_type(type: SlotTypes) -> Texture2D:
	match type:
		SlotTypes.RANGE:
			return load("uid://dfsmxavxasx7x")
		SlotTypes.BOOL:
			return load("uid://4b3i1xqd4052")
		SlotTypes.DATA:
			return load("uid://yo87adchyr3w")
		SlotTypes.MAP:
			return load("uid://d2rmsal7c6sdi")
		SlotTypes.MATERIAL:
			return load("uid://daasmk1v2rpcm")
		SlotTypes.VECTOR3:
			return load("uid://dbvw3j8fnmhpu")
		SlotTypes.VECTOR2:
			return load("uid://bidpo1iw1t0vt")
		SlotTypes.GRADIENT:
			return load("uid://ccqq5l0ruur37")

	return load("uid://dqob6v3dudlri")
