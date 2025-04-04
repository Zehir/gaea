@tool
class_name RandomMaterial
extends GaeaMaterial


@export var materials: Array[GaeaMaterial] :
	set(value):
		var pre_size: int = materials.size()
		materials = value
		
		#Resize the weights array to match the materials array size
		if materials.size() > pre_size:
			weights.resize(value.size())
			weights[-1] = 100
		elif materials.size() < pre_size:
			weights.resize(value.size())
		
		notify_property_list_changed()


##Represent the weight of each material.[br]
##For example, if you want to change the probability of using the first material, you need to modify the value of the first element in the weight array.[br]
##Higher values increase the chances of obtaining the material.[br]
##The object picked is determined by the [method RandomNumberGenerator.rand_weighted] function, [url=https://docs.godotengine.org/en/latest/tutorials/math/random_number_generation.html#weighted-random-probability]check the documentation here.[/url]
@export var weights: PackedInt32Array : 
	#Avoid editing the weights array size
	set(value):
		if value.size() == materials.size():
			weights = value


func get_random_material_index() -> int:
	var weights_sum: int = 0
	for weight in weights:
		weights_sum += weight

	var remaining_distance: int = randf() * weights_sum
	for i in range(weights.size()):
		remaining_distance -= weights[i]
		if remaining_distance < 0:
			return i
	
	return -1


##Return the random picked material. 
func get_resource() -> GaeaMaterial:
	var material_index: int = get_random_material_index()
	
	if material_index != -1:
		return materials[material_index]
	return null
