extends Resource
class_name RecipeBook

@export var recipes : Array[Recipe]

func _init(arrayRecipe : Array[Recipe] = [null]) -> void:
	recipes = arrayRecipe
