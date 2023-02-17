extends Resource
class_name Item

signal useEffect

@export var itemName : String
@export var effectType : ItemEffect
@export var icon : Texture2D
@export var amount : int
@export var stack : int
@export var canBeEquiped : bool
@export var canBeUpgraded : bool
@export var description : String


func _init(item_name : String = "", itemType : ItemEffect = ItemEffect.new(), new_icon : Texture2D = load("res://icon.svg") , quantity : int = 1, stackSize : int = 64, isEquipment : bool = false, isUpgradable : bool = false, itemDescription : String = "a cool item"):
	itemName = item_name
	effectType = itemType
	icon = new_icon
	amount = quantity
	stack = stackSize
	canBeEquiped = isEquipment
	canBeUpgraded = isUpgradable
	description = itemDescription
	
	connect("useEffect", UseEffect.use)

func effect():
	useEffect.emit(effectType)


