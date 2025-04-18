@tool
class_name GaeaNodeSlotOutput extends GaeaNodeSlot


@export var name: StringName = &"":
	set(new_value):
		name = new_value
		if not resource_path.ends_with(".tres"):
			resource_name = new_value.capitalize()
@export var type: SlotType = SlotType.NUMBER:
	set(new_value):
		type = new_value
		notify_property_list_changed()
