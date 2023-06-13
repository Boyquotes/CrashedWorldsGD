extends Resource
class_name Loot

# ------------------------------------------------------------------------------ PUBLIC PROPERTIES
@export var item : Item
@export var percentage : int = 0

# ------------------------------------------------------------------------------ BASIC METHODS
func _init(itemToDrop : Item = null, chanceToDrop : int = 50) -> void:
	item = itemToDrop
	percentage = chanceToDrop 
