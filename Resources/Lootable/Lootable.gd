extends Resource
class_name Lootable
# ------------------------------------------------------------------------------ PUBLIC PROPERTIES

## Array of Loots
@export var loots : Array[Loot]

## Minimum amount of items that can be dropped by that loot. 
## For a certain number minNumberLoot = maxNumberLoot
@export var minNumberLoot : int = 0

## Maximum amount of items that can be dropped by that loot. 
## For a certain number minNumberLoot = maxNumberLoot
@export var maxNumberLoot : int = 1

# ------------------------------------------------------------------------------ PRIVATE PROPERTIES

# ------------------------------------------------------------------------------ BASIC METHODS

## Basic init function.
func _init(itemsToLoot : Array[Loot] = [null], minNbLoot : int = 0, maxNbLoot : int = 1) -> void:
	loots = itemsToLoot
	minNumberLoot = minNbLoot
	maxNumberLoot = maxNbLoot

# ------------------------------------------------------------------------------ CUSTOM METHODS

## Calculate how many and which items needs to be dropped.
## return an array of Items.
func dropLoot() -> Array[Item]:
	var itemDropped : Array[Item] = []
	var howManyDrops : int = randi_range(minNumberLoot, maxNumberLoot)
	
	var totalChances : int = 0
	for i in loots: # We add all chances
		totalChances += i.percentage
	
	for i in range(howManyDrops): # Creating all loot
		# Calculating which loot just dropped
		var rand : int = randi_range(0, totalChances) # actual number we're looking for
		
		var idx : int = 0 # current looking number
		
		# Checking if number is inside loot.percentage
		for y in loots: 
			idx += y.percentage
			if idx >= rand : # found it ! 
				itemDropped.append(y.item)
				break 

	return itemDropped

# ------------------------------------------------------------------------------ SIGNALS


