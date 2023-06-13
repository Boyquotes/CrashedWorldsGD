extends Resource
class_name Recipe

@export var inputItems : Array[ItemHolder] = []
@export var outputItem : ItemHolder

func _init(input_items : Array[ItemHolder] = [], output_Item : ItemHolder = null):
	inputItems = input_items
	outputItem = output_Item
