@tool
class_name GaeaTypes extends RefCounted

enum Values {
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
	RANGE = 100,
	MATERIAL = 101,
	GRADIENT = 102,
	# Dictionary types from 200 to 299
	DATA = 200,
	MAP = 201,
	# Inner types (can't be on wire) from 300 to 399
	BITMASK = 300, ## Int representing a bitmask.
	BITMASK_EXCLUSIVE = 301, ## Same as bitmask but only one bit can be active at once.
	FLAGS = 302, ## Same interface as bitmask, but returns an Array of flags.
	NEIGHBOR = 303,
	RULES = 304,
	VARIABLE_NAME = 305,
}


static func is_value_wireable(type: Values) -> bool:
	return type > 0 and type < 300


static func get_value_color(type: Values) -> Color:
	return GaeaEditorSettings.get_configured_color_for_value_type(type)


static func get_value_default_color(type: Values) -> Color:
	match type:
		# Basic types
		Values.BOOLEAN:
			return Color("ffdd59") # YELLOW
		Values.INT, Values.FLOAT:
			return Color("a0a0a0") # GRAY
		Values.VECTOR2:
			return Color("00bfff") # LIGHT BLUE
		Values.VECTOR3:
			return Color("8e44ad") # MAGENTA
		# Simple types
		Values.RANGE:
			return Color("f04c7f") # PINK
		Values.MATERIAL:
			return Color("eb2f06") # RED
		Values.GRADIENT:
			return Color("4834d4") # BLURPLE
		# Dictionary types
		Values.DATA:
			return Color("f0f8ff") # WHITE
		Values.MAP:
			return Color("27ae60") # GREEN
		# Reserved for later use
		#SlotType.TEXTURE: # ORANGE
		#	return Color("e67e22")
	return Color.WHITE


## Get icon for the GraphNode slot
static func get_value_display_icon(type: Values) -> Texture2D:
	match type:
		# Basic types
		Values.BOOLEAN:
			return load("uid://0l53mu4blspj")
		Values.INT:
			return load("uid://bilsfh3nrbhkl")
		Values.FLOAT:
			return load("uid://baw7ye0h4xdcx")
		Values.VECTOR2:
			return load("uid://c8uvy6c2syjk5")
		Values.VECTOR3:
			return load("uid://bkknri7u8ghs4")
		# Simple types
		Values.RANGE:
			return load("uid://wx4ccwofr8yy")
		Values.MATERIAL:
			return load("uid://b0vqox8bodse")
		Values.GRADIENT:
			return load("uid://lx5rvgl4j7wl")
		# Dictionary types
		Values.DATA:
			return load("uid://dkccxw7yq1mth")
		Values.MAP:
			return load("uid://c2i5wqidu1r1o")
	return load("uid://by6s78k1thpy2")


## Get icon for the GraphNode slot
static func get_value_slot_icon(type: Values) -> Texture2D:
	return GaeaEditorSettings.get_configured_icon_for_value_type(type)


## Get default icon for the GraphNode slot
static func get_value_default_slot_icon(type: Values) -> Texture2D:
	match type:
		# Basic types
		Values.BOOLEAN:
			return load("uid://4b3i1xqd4052")
		Values.INT, Values.FLOAT:
			return load("uid://dqob6v3dudlri")
		Values.VECTOR2:
			return load("uid://bidpo1iw1t0vt")
		Values.VECTOR3:
			return load("uid://dbvw3j8fnmhpu")
		# Simple types
		Values.RANGE:
			return load("uid://dfsmxavxasx7x")
		Values.MATERIAL:
			return load("uid://daasmk1v2rpcm")
		Values.GRADIENT:
			return load("uid://ccqq5l0ruur37")
		# Dictionary types
		Values.DATA:
			return load("uid://yo87adchyr3w")
		Values.MAP:
			return load("uid://d2rmsal7c6sdi")
	return load("uid://dqob6v3dudlri")
