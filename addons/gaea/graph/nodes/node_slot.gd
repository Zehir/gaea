@tool
class_name GaeaNodeSlot extends Resource

enum DataType {
	# Misc types
	CATEGORY = -1, ## For visual separation, doesn't get saved.
	NULL = TYPE_NIL,
	# Basic types from 1 to TYPE_MAX but reserved to 99
	BOOLEAN = TYPE_BOOL,
	INT = TYPE_INT,
	FLOAT = TYPE_FLOAT,
	VECTOR2 = TYPE_VECTOR2,
	VECTOR3 = TYPE_VECTOR3,
	# Simple types from 100 to 199
	RANGE = 101,
	MATERIAL = 102,
	GRADIENT = 103,
	# Dictionary types from 200 to 299
	DATA = 201,
	MAP = 202,
	# Inner types (can't be on wire) from 300 to 399
	BITMASK = 301, ## Int representing a bitmask.
	BITMASK_EXCLUSIVE = 302, ## Same as bitmask but only one bit can be active at once.
	FLAGS = 303, ## Same interface as bitmask, but returns an Array of flags.
	NEIGHBOR = 304,
	RULES = 305,
	VARIABLE_NAME = 306,
}



static func get_default_color(type: DataType) -> Color:
	match type:
		# Basic types
		DataType.BOOLEAN:
			return Color("ffdd59") # YELLOW
		DataType.INT, DataType.FLOAT:
			return Color("a0a0a0") # GRAY
		DataType.VECTOR2:
			return Color("00bfff") # LIGHT BLUE
		DataType.VECTOR3:
			return Color("8e44ad") # MAGENTA
		# Simple types
		DataType.RANGE:
			return Color("f04c7f") # PINK
		DataType.MATERIAL:
			return Color("eb2f06") # RED
		DataType.GRADIENT:
			return Color("4834d4") # BLURPLE
		# Dictionary types
		DataType.DATA:
			return Color("f0f8ff") # WHITE
		DataType.MAP:
			return Color("27ae60") # GREEN
		# Reserved for later use
		#SlotType.TEXTURE: # ORANGE
		#	return Color("e67e22")
	return Color.WHITE


## Get icon for the GraphNode slot
static func get_type_slot_icon(type: SlotType) -> Texture2D:
	match type:
		SlotType.RANGE:
			return load("uid://dfsmxavxasx7x")
		SlotType.BOOL:
			return load("uid://4b3i1xqd4052")
		SlotType.DATA:
			return load("uid://yo87adchyr3w")
		SlotType.MAP:
			return load("uid://d2rmsal7c6sdi")
		SlotType.MATERIAL:
			return load("uid://daasmk1v2rpcm")
		SlotType.VECTOR3:
			return load("uid://dbvw3j8fnmhpu")
		SlotType.VECTOR2:
			return load("uid://bidpo1iw1t0vt")
		SlotType.GRADIENT:
			return load("uid://ccqq5l0ruur37")

	return load("uid://dqob6v3dudlri")
