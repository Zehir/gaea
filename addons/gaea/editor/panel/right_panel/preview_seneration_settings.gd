@tool
class_name GaeaPreviewGenerationSettings
extends GaeaGenerationSettings


enum WorldSizePreset {SINGLE_2D, CHUNK_2D, SINGLE_3D, CHUNK_3D, CUSTOM}
@export var world_size_preset: WorldSizePreset = WorldSizePreset.SINGLE_2D


func _init() -> void:
	world_size = property_get_revert(&"world_size")
	cell_size = property_get_revert(&"cell_size")


func _property_can_revert(property: StringName) -> bool:
	if property == &'world_size' or property == &'cell_size':
		return true
	return super(property)


func _property_get_revert(property: StringName) -> Variant:
	if property == &'world_size':
		var size: Vector3 = Vector3.ONE * GaeaEditorSettings.get_preview_resolution()
		if world_size_preset == WorldSizePreset.SINGLE_2D or world_size_preset == WorldSizePreset.CHUNK_2D:
			size.z = 1
		return Vector3i(size)

	if property == &'cell_size':
		var size: Vector3 = _property_get_revert(&'world_size')
		if world_size_preset == WorldSizePreset.SINGLE_2D or world_size_preset == WorldSizePreset.SINGLE_3D:
			return Vector3i(size)
		return Vector3i((size * 0.25).ceil())
	return super(property)


func _validate_property(property: Dictionary) -> void:
	if property.name.begins_with(&"resource_"):
		property.usage = PROPERTY_USAGE_NONE

	if property.name == &"world_size" or property.name == &"cell_size":
		property.type = TYPE_VECTOR3
		property.hint = property.hint | PROPERTY_HINT_RANGE
		property.hint_string = "0,%d,1" % GaeaEditorSettings.get_preview_max_simulation_size()
