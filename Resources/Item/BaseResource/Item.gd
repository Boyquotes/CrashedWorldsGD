extends Resource
class_name Item

enum types {
	BLOC, WEAPON, SPELL, TOOL, LOOT
}

@export var itemName : String
@export var type : types
@export var icon : Texture2D
@export var amount : int
@export var stack : int
@export var canBeEquiped : bool
@export var canBeUpgraded : bool
@export var description : String


func _init(item_name : String = "", itemType : types = types.BLOC, new_icon : Texture2D = load("res://icon.svg") , quantity : int = 1, stackSize : int = 64, isEquipment : bool = false, isUpgradable : bool = false, itemDescription : String = "a cool item"):
	itemName = item_name
	type = itemType
	icon = new_icon
	amount = quantity
	stack = stackSize
	canBeEquiped = isEquipment
	canBeUpgraded = isUpgradable
	description = itemDescription
