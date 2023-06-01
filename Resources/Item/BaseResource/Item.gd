extends Resource
class_name Item


@export var itemName : String
@export var type : String
@export var icon : Texture2D
@export var amount : int
@export var stack : int
@export var canBeEquiped : bool
@export var description : String
@export var objectScenePath : String

@export var upgrades : Array[Recipe]


func _init(item_name : String = "", itemType : String = "",
	new_icon : Texture2D = load("res://icon.svg") , 
	quantity : int = 1, stackSize : int = 64, 
	isEquipment : bool = false, 
	itemDescription : String = "a cool item", 
	objectscene : String = "", upgradelist : Array[Recipe] = []):
	itemName = item_name
	icon = new_icon
	amount = quantity
	stack = stackSize
	canBeEquiped = isEquipment
	description = itemDescription
	objectScenePath = objectscene
	type = itemType
	upgrades = upgradelist


