extends Resource
class_name Recipe

@export var inputItems : Array[Item] = []
@export var outputItem : Item

func _init(input_items : Array[Item] = [], output_Item : Item = null):
	inputItems = input_items
	outputItem = output_Item
