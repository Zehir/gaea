@tool
class_name RandomMaterial
extends GaeaMaterial


@export var materials: Array[GaeaMaterial] :
	set(value):
		materials = value
		weights.resize(materials.size())
		weights[-1] = 1.0
		
		notify_property_list_changed()


##Represent the weight of each material.[br]
##For example, if you want to change the probability of spawning the first material, you need to modify the value of the first element in the weight array.[br]
##Higher values increase the chances of obtaining the material.[br]
##The object picked is determined by the [method RandomNumberGenerator.rand_weighted] function, [url=https://docs.godotengine.org/en/latest/tutorials/math/random_number_generation.html#weighted-random-probability]check the documentation here.[/url]
@export var weights: PackedFloat32Array : 
	#Avoid editing the weights array
	set(value):
		if value.size() == materials.size():
			weights = value


##Return the random picked material. 
func get_resource() -> GaeaMaterial:
	var random = RandomNumberGenerator.new()
	return materials[random.rand_weighted(weights)]
