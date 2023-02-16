extends Resource
class_name Item

@export var itemName : String
@export var icon : Texture2D
@export var amount : int
@export var canBeEquiped : bool
@export var canBeUpgraded : bool
@export var description : String

func _init(item_name : String = "", new_icon : Texture2D = load("res://icon.svg") , quantity : int = 1, isEquipment : bool = false, isUpgradable : bool = false, itemDescription : String = "a cool item"):
	itemName = item_name
	icon = new_icon
	amount = quantity
	canBeEquiped = isEquipment
	canBeUpgraded = isUpgradable
	description = itemDescription
