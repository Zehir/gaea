@tool
class_name GaeaPreviewGenerationSettings
extends GaeaGenerationSettings

func _validate_property(property: Dictionary) -> void:
	if property.name.begins_with(&"resource_"):
		property.usage = PROPERTY_USAGE_NONE

	if property.name == &"world_size" or property.name == &"cell_size":
		property.type = TYPE_VECTOR3
		property.hint = property.hint | PROPERTY_HINT_RANGE
		property.hint_string = "0,%d,1" % GaeaEditorSettings.get_preview_max_simulation_size()
