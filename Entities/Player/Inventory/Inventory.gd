extends CanvasLayer

# ------------------------------------------------------------------------------ VARIABLES
@export var craftRecipes : RecipeBook

@onready var inst_recipe = preload("res://UI/Nodes/RecipeNode/RecipeNode.tscn")

@onready var bloc = preload("res://Resources/Item/Lootables/Berries/RedBerry.tres")
@onready var inst = preload("res://Entities/Player/Inventory/InvSlot.tscn")

var button_hovered = null
var drag : bool = false
var itemHold : Item
var currentItemSlot = null
# ------------------------------------------------------------------------------ BASIC METHODS

func _ready():
	# Inventory Setup (32 slots)
	for i in range(0,31):
		var thing = inst.instantiate()
		$Bag.add_child(thing)

	# Connecting the slots
	for i in $Bag.get_children():
		i.connect("onPressed", _on_button_pressed)
		i.connect("onMouseHover", _on_slot_mouse_entered)
		i.connect("onMouseLeft", _on_slot_mouse_exited)

	# Special connection for the equipment slot
	$Equipment.connect("onPressed", _on_button_pressed)
	$Equipment.connect("onMouseHover", _on_slot_mouse_entered)
	$Equipment.connect("onMouseLeft", _on_slot_mouse_exited)
	$Equipment.connect("equipedItem", get_parent().equip)

	# Creation of the recipe list
	for recipe in craftRecipes.recipes:
		var ins = inst_recipe.instantiate()
		%ItemList/MarginContainer/Boundings/Holder.add_child(ins)
		ins.set_recipe(recipe)
		ins.connect("recipeClicked", add_to_do_recipe)

	# Connection of the ToDoList boxes
	for todobox in $ToDoList/Body.get_children():
		todobox.get_node("PinBox").connect("keyPressed", do_recipe)


func _unhandled_input(event):
	if event.is_action_pressed("RMB"): # Hide recipe list
		%ItemList.hide()
		%UpgradeList.hide()
	if event.is_action_pressed("Interact"): # Open / close inventory
		button_hovered = null
		if $Bag.visible:
			$Bag.hide()
			%ItemList.hide()
			%UpgradeList.hide()
		else:
			$Bag.show()

func _input(event):
	if event.is_action_pressed("LMB") and button_hovered:
		if button_hovered.itemHolding:
			drag = true
			itemHold = button_hovered.itemHolding

	if event.is_action_released("LMB") :
		drag = false

		if button_hovered == currentItemSlot : return # trying to place item on same slot

		if itemHold and currentItemSlot:
			move_item_to(currentItemSlot)

		itemHold = null

	if drag and itemHold != null:
		if event is InputEventMouseMotion:
			if $Marker.visible == false : $Marker.show()
			$Marker.global_position = event.position - Vector2(16.0,16.0)
	else:
		$Marker.hide()

# ------------------------------------------------------------------------------ CUSTOM METHODS

## Adds the item to the first empty slots. Returns true if successful.
func add_item(item: Item) -> bool:
	item = item.duplicate()
	for i in $Bag.get_children():

		# Slot is empty
		if i.itemHolding == null:
			i.itemHolding = item
			return true

		# Slot has the same item
		elif i.itemHolding.itemName == item.itemName:
			# if under the stack limit
			if i.itemHolding.amount + 1 <= i.itemHolding.stack:
				i.itemHolding.amount += 1
				return true
	return false

## Moves an item from a slot to another, by duplicating the first one then deleting the other.
func move_item_to(slot: InventorySlot):
	if slot.itemHolding:
		if slot.itemHolding.itemName == itemHold.itemName:
			if slot.itemHolding.amount + 1 > slot.itemHolding.stack:
				if !add_item(itemHold):
					return
			else:
				slot.itemHolding.amount += itemHold.amount
		else:
			var temp = slot.itemHolding
			slot.itemHolding = itemHold
			button_hovered.itemHolding = temp
			if slot.name == "Equipment":
				get_parent().equip(itemHold)
			button_hovered = null
			itemHold = null; currentItemSlot = null

			return
	else:
		slot.itemHolding = itemHold
	delete_item_at(button_hovered)
	button_hovered = null
	itemHold = null; currentItemSlot = null

## Deletes item at selected slot.
func delete_item_at(slot: InventorySlot):
	slot.itemHolding = null

## Find the first instance of an item to remove the needed quantity. Returns true if successful.
func buy_item(item : Item, quantity : int, start_child : int = 0) -> bool:
	# We iterate to find the first instance. If enough, we're done.
	# else, we try to find another one, using recursivity with what's left.
	# Then, the function will collapse on the answer, that being true or false.
	for i in range(start_child, $Bag.get_child_count()):
		var child = $Bag.get_child(i)
		if child.itemHolding:
			if child.itemHolding.itemName == item.itemName:
				if quantity <= child.itemHolding.amount:
					child.itemHolding.amount -= quantity
					if child.itemHolding.amount == 0 : delete_item_at(child)
					return true

				if buy_item(item, quantity - child.itemHolding.amount, i + 1):
					child.itemHolding.amount -= quantity
					if child.itemHolding.amount <= 0 : delete_item_at(child)
					return true
				else:
					return false

	return false
	# For instance, I have a headache because of this function

func do_recipe(pinbox : Pinbox):
	for i in pinbox.current_recipe.inputItems:
		if !buy_item(i, i.amount):
			return false

	add_item(pinbox.current_recipe.outputItem)
	pinbox.get_parent().hide()
	pinbox.current_recipe = null

func add_to_do_recipe(recipe : Recipe) -> bool:

	# We're using the visibility as a bool to check if the recipe can be done.
	for i in $ToDoList/Body.get_children():
		if !i.visible:
			i.get_node("PinBox").set_recipe(recipe)
			i.show()

			return true
	return false

# ------------------------------------------------------------------------------ SIGNALS

func _on_button_pressed(button):
	button_hovered = button

	# CRAFT BEHAVIOUR
	if button.itemHolding == null:
		%ItemList.show()

	# UPGRADE
	else:
		$Marker.texture = button.itemHolding.icon
		for i in %UpgradeList/MarginContainer/Boundings/Holder.get_children():
			i.queue_free()

		if button.itemHolding.upgrades != null:
			for upgrade in button.itemHolding.upgrades:
				var ins = inst_recipe.instantiate()
				%UpgradeList/MarginContainer/Boundings/Holder.add_child(ins)
				ins.set_recipe(upgrade)
				ins.connect("recipeClicked", add_to_do_recipe)
			%UpgradeList.show()


func _on_slot_mouse_entered(slot : InventorySlot):
	if drag and itemHold:
		if slot.itemHolding == null:
			slot.get_node("InvSlot").show()
			slot.update_icons(itemHold.icon)
			slot.self_modulate = Color.GRAY

	currentItemSlot = slot


func _on_slot_mouse_exited(slot):
	if slot.itemHolding == null:
		if drag and itemHold:
			slot.update_icons(null)
			slot.self_modulate = Color.WHITE
