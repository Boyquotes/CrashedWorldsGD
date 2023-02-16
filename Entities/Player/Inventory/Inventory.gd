extends CanvasLayer

# ------------------------------------------------------------------------------ VARIABLES
@export var craftRecipes : RecipeBook
@export var upgradeRecipes : RecipeBook

@onready var bloc = preload("res://Resources/Item/Bloc.tres")
@onready var inst = preload("res://Entities/Player/Inventory/InvSlot.tscn")

var button_hovered = null
var drag : bool = false
var itemHold : Item
var currentItemSlot = null
# ------------------------------------------------------------------------------ BASIC METHODS

func _ready():
	for i in range(0,31):
		var thing = inst.instantiate()
		$Bag.add_child(thing)
	
	for i in $Bag.get_children():
		i.connect("onPressed", _on_button_pressed)
		i.connect("onMouseHover", _on_slot_mouse_entered)
		i.connect("onMouseLeft", _on_slot_mouse_exited)
	
	
	$Equipment.connect("onPressed", _on_button_pressed)
	$Equipment.connect("onMouseHover", _on_slot_mouse_entered)
	$Equipment.connect("onMouseLeft", _on_slot_mouse_exited)
	$Equipment.connect("equipedItem", get_parent().equip)
	
	


func _unhandled_input(event):
	if event.is_action_pressed("RMB"):
		$ItemList.hide()
	if event.is_action_pressed("ui_cancel"):
		button_hovered = null
		if $Bag.visible:
			$Bag.hide()
			$ItemList.hide()
		else:
			$Bag.show()

func _input(event):
	if event.is_action_pressed("LMB") and button_hovered:
		if button_hovered.itemHolding:
			drag = true
			itemHold = button_hovered.itemHolding
	if event.is_action_released("LMB") : 
		drag = false
		if itemHold and currentItemSlot:
			move_item_to(currentItemSlot)
			print("moved")
	
	if drag and itemHold != null: 
		if event is InputEventMouseMotion:
			$Marker.show()
			$Marker.global_position = event.position - Vector2(16.0,16.0)
	else:
		$Marker.hide()

# ------------------------------------------------------------------------------ CUSTOM METHODS

func add_item(item) -> bool:
	for i in $Bag.get_children():
		if i.itemHolding == null:
			i.itemHolding = item
			return true
		elif i.itemHolding.itemName == item.itemName:
			i.itemHolding.amount += 1
			return true
	return false

func craft_item(item):
	if button_hovered:
		button_hovered.itemHolding = item
		$Marker.texture = item.icon
		button_hovered = null

func move_item_to(slot):
	if slot.itemHolding:
		if slot.itemHolding.itemName == itemHold.itemName:
			if slot.itemHolding.amount + 1 > slot.itemHolding.stack:
				if !add_item(itemHold):
					return
			slot.itemHolding.amount += itemHold.amount
	else:
		slot.itemHolding = itemHold
	delete_item(button_hovered)
	button_hovered = null
	itemHold = null; currentItemSlot = null

func equip_item(_item):
	pass

func unequip_item(_slot):
	pass

func delete_item(slot):
	button_hovered.itemHolding = null
# ------------------------------------------------------------------------------ SIGNALS

func _on_button_pressed(button):
	button_hovered = button
	
	# CRAFT BEHAVIOUR
	if button.itemHolding == null:
		$ItemList.show()
		$ItemList.global_position = button.global_position + Vector2(55,0)
		
	# UPGRADE
	else:
		print("true")

func _on_item_list_item_activated(index):
	craft_item(bloc)

func _on_slot_mouse_entered(slot):
	if drag and itemHold:
		slot.get_node("InvSlot").show()
		slot.update_icons(itemHold.icon)
		slot.self_modulate = Color.GRAY
		currentItemSlot = slot

func _on_slot_mouse_exited(slot):
	if drag and itemHold: 
		slot.get_node("InvSlot").hide()
		slot.self_modulate = Color.WHITE
		
