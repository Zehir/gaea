@tool
class_name GaeaNodeSlot extends Resource

const SLOT_SCENE = preload("uid://cqpby5jyv71l0")

enum SlotType {
	BOOL = 6,
	NUMBER = 4,
	VECTOR2 = 3,
	VECTOR3 = 7,
	RANGE = 5,
	DATA = 0,
	MAP = 1,
	MATERIAL = 2,
	GRADIENT = 8,
	NULL = -1,
}


static func get_color(type: SlotType) -> Color:
	match type:
		SlotType.DATA:
			return Color("f0f8ff") # WHITE
		SlotType.MAP:
			return Color("27ae60") # GREEN
		SlotType.MATERIAL:
			return Color("eb2f06") # RED
		SlotType.VECTOR2:
			return Color("00bfff") # LIGHT BLUE
		SlotType.VECTOR3:
			return Color("8e44ad") # MAGENTA
		SlotType.NUMBER:
			return Color("a0a0a0") # GRAY
		SlotType.RANGE:
			return Color("f04c7f") # PINK
		SlotType.BOOL:
			return Color("ffdd59") # YELLOW
		SlotType.GRADIENT:
			return Color("4834d4") # BLURPLE
		#SlotType.TEXTURE: # Reserved Orange for later use.
		#	return Color("e67e22")
	return Color.WHITE

## Get icon for menu
static func get_display_icon(slot_type: SlotType) -> Texture2D:
	match slot_type:
		SlotType.BOOL:
			return preload("uid://0l53mu4blspj")
		SlotType.DATA:
			return preload("uid://dkccxw7yq1mth")
		SlotType.MAP:
			return preload("uid://c2i5wqidu1r1o")
		SlotType.MATERIAL:
			return preload("uid://b0vqox8bodse")
		SlotType.VECTOR2:
			return preload("uid://c8uvy6c2syjk5")
		SlotType.NUMBER:
			return preload("uid://by6s78k1thpy2")
		SlotType.RANGE:
			return preload("uid://wx4ccwofr8yy")
		SlotType.VECTOR3:
			return preload("uid://bkknri7u8ghs4")
	return null

## Get icon for the GraphNode slot
static func get_connection_icon(type: SlotType) -> Texture2D:
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
