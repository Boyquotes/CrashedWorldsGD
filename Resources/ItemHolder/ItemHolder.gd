extends Resource
## ItemHolder class. 
## Used to separate the declarative function of the item from the usage.
class_name ItemHolder

# ------------------------------------------------------------------------------ PUBLIC PROPERTIES
## Item linked to the resource.
@export var item : Item
## Quantity of said item.
@export var quantity : int = 0
# ------------------------------------------------------------------------------ PRIVATE PROPERTIES

# ------------------------------------------------------------------------------ BASIC METHODS

## Basic init method.
func _init(holdedItem : Item = null, amount : int = 0) -> void:
	item = holdedItem
	quantity = amount
	
# ------------------------------------------------------------------------------ CUSTOM METHODS

## Add quantity to resource. return true if correctly done.
## By default, will add one.
func addAmount(amount : int = 1) -> bool:
	if quantity + amount < 0 : return false
	if quantity + amount >= item.stack : return false
	quantity += amount
	return true

## Remove quantity to resource. return true if correctly done.
## By default, will remove one.
func removeAmount(amount : int = 1) -> bool:
	if quantity - amount < 0 : return false
	if quantity - amount > item.stack : return false # why bro
	quantity -= amount
	return true

## Return the amount of item left until stack is reached
func spaceUntilStack() -> int:
	return item.stack - quantity

# ------------------------------------------------------------------------------ SIGNALS


