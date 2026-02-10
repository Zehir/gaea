@tool
extends RefCounted

## Shared class that holds enums used across multiple nodes and components.
class_name GaeaEnums


enum CellCheckMode {
	BOOLEAN,   # checked / unchecked
	TRISTATE,  # checked / crossed / empty
}


enum CellCoordinateFormat {
	ALIGNED_3D,
	ALIGNED_2D,
	VERTICAL_OFFSET_2D,
	HORIZONTAL_OFFSET_2D,
}
