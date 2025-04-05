@tool
## A material that randomly selects between multiple materials.[br]
## [br]
## This class allows you to create a material that will randomly choose between a set of provided materials.[br]
## Each material can have a different weight assigned to it, which affects its probability of being selected.[br]
## [br]
## Example:[br]
## [codeblock]
## var random_material = RandomMaterial.new()
## random_material.materials = [grass_material, stone_material]
## random_material.weights = [70.0, 30.0]
## # 70% chance for grass, 30% for stone
## [/codeblock]
class_name RandomMaterial extends GaeaMaterial

var _random = RandomNumberGenerator.new()

## An array of materials to randomly choose from.[br]
## Each material in this array has a chance to be selected during [method get_resource] calls.[br]
## The probability of each material being selected is determined by its corresponding value in the [member weights] array.
@export var materials: Array[GaeaMaterial]:
	set(value):
		var pre_size: int = materials.size()
		materials = value

		#Resize the weights array to match the materials array size
		if materials.size() > pre_size:
			weights.resize(value.size())
			for index in range(pre_size, materials.size()):
				weights[index] = 100.0
		elif materials.size() < pre_size:
			weights.resize(value.size())

		notify_property_list_changed()

## Represent the weight of each material.[br]
## For example, if you want to change the probability of using the first material, you need to modify the value of the first element in the weight array.[br]
## Higher values increase the chances of obtaining the material.[br]
## The default weight value for new materials is [code]100.0[/code].[br]
## The object picked is determined by the [method RandomNumberGenerator.rand_weighted] function.
@export var weights: PackedFloat32Array:
	#Avoid editing the weights array size
	set(value):
		if value.size() == materials.size():
			weights = value


## Return the random picked material.
func get_resource() -> GaeaMaterial:
	var material_index: int = _random.rand_weighted(weights)

	if material_index != -1:
		return materials[material_index]
	return null
