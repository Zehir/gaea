@tool
class_name GaeaPreviewPanel
extends Control

class _FakeResource extends RefCounted:
	@warning_ignore("shadowed_global_identifier")
	var seed: int
	@export var property: GaeaGenerationSettings

var settings: GaeaPreviewGenerationSettings
var _settings_inspector: EditorInspector


@export var main_editor: GaeaMainEditor

@onready var generation_settings_container: VBoxContainer = %GenerationSettingsContainer


var generation_settings: GaeaGenerationSettings
var generation_settings_inspector: EditorInspector
var test_object: _FakeResource

func _ready() -> void:
	if is_part_of_edited_scene() or not is_instance_valid(main_editor):
		return


	generation_settings = GaeaGenerationSettings.new()
	_on_button_pressed()


func _on_button_pressed() -> void:
	for child in generation_settings_container.get_children():
		child.queue_free()

	#generation_settings = GaeaGenerationSettings.new()
	#generation_settings_inspector = EditorInspector.new()
	_build_inspector_5()



@warning_ignore("shadowed_variable_base_class")
static func get_property(object: Object, name: StringName) -> Dictionary:
	if !object:
		push_error("object is null")
	var props := object.get_property_list()
	for p in props:
		if p.name == name:
			return p
	return {}

func _build_inspector_3() -> void:
	test_object = _FakeResource.new()
	var property = get_property(test_object, "property")
	print(property)
	var editor = EditorInspector.instantiate_property_editor(
		test_object,
		property.type,
		property.name,
		property.hint,
		property.hint_string,
		property.usage
	)

	generation_settings_container.add_child(editor)

func _build_inspector_2() -> void:

	test_object = _FakeResource.new()
	test_object.set("property", GaeaGenerationSettings.new())
	var editor = EditorInspector.instantiate_property_editor(
		test_object,
		TYPE_OBJECT,
		"property",
		PROPERTY_HINT_RESOURCE_TYPE,
		"GaeaGenerationSettings",
		PROPERTY_USAGE_STORAGE | PROPERTY_USAGE_EDITOR | PROPERTY_USAGE_SCRIPT_VARIABLE,
	)
	editor.label = "Foo"
	editor.property_changed.connect(value_changed)
	editor.set_object_and_property(test_object, "property")

	generation_settings_container.add_child(editor)


func value_changed(property: StringName, value: Variant, field: StringName, changing: bool):
	prints(property, value, field, changing)


func _build_inspector_first() -> void:
	for property in generation_settings.get_property_list():
		if not [&"random_seed_on_generate", &"seed", &"world_size", &"cell_size"].has(property.name):
			continue

		#generation_settings_inspector.edit(generation_settings)
		var editor: EditorProperty = EditorInspector.instantiate_property_editor(
			generation_settings, property.type, property.name, property.hint, property.hint_string, property.usage, true
		)
		editor.label = property.name.capitalize()

		editor.set_object_and_property(generation_settings, property.name)

		generation_settings_container.add_child(editor)





class Test4 extends GaeaGenerationSettings:
	func _validate_property(property: Dictionary) -> void:
		#if not [&"random_seed_on_generate", &"seed", &"world_size", &"cell_size"].has(property.name):
		#	property.usage = PROPERTY_USAGE_NONE
		print(property)


func _build_inspector_4() -> void:
	var test_object2 = Test4.new()

	for property in test_object2.get_property_list():
		if not [&"random_seed_on_generate", &"seed", &"world_size", &"cell_size"].has(property.name):
			continue
		var editor = EditorInspector.instantiate_property_editor(
			test_object2,
			property.type,
			property.name,
			property.hint,
			property.hint_string,
			property.usage,
		)
		editor.label = property.name.capitalize()
		editor.property_changed.connect(value_changed)
		editor.set_object_and_property(test_object2, "property")
		generation_settings_container.add_child(editor)



class Test5 extends RefCounted:
	@export var copyright: String = ""

func _build_inspector_5() -> void:
	print("_build_inspector_5")

	settings = GaeaPreviewGenerationSettings.new()
	_settings_inspector = EditorInspector.new()
	_settings_inspector.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_settings_inspector.edit(null)
	_settings_inspector.edit(settings)
	_settings_inspector.property_edited.connect(value_changed2)

	generation_settings_container.add_child(_settings_inspector)

	patch_slider.call_deferred()

func value_changed2(property_name: StringName):
	prints("value_changed2", property_name, settings.get(property_name))


func patch_slider():
	# Workaround until this issue is resolved : https://github.com/godotengine/godot/issues/112647
	await get_tree().create_timer(0.5).timeout
	for editor_property_vector3 in _settings_inspector.find_children("*", "EditorPropertyVector3", true, false):
		for node in editor_property_vector3.find_children("*", "EditorSpinSlider", true, false):
			if node is EditorSpinSlider:
				node.allow_lesser = false
				node.allow_greater = false
