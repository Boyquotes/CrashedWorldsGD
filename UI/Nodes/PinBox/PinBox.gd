extends MarginContainer
class_name Pinbox

signal keyPressed

@export var key : String = ""
var current_recipe : Recipe = null

@onready var itembox = load("res://UI/Nodes/ItemBox/ItemBox.tscn")

func set_recipe(recipe : Recipe):
	for i in $Boundings/Body/Inputs.get_children():
		i.queue_free()
	current_recipe = recipe
	for i in recipe.inputItems:
		var inst = itembox.instantiate()
		$Boundings/Body/Inputs.add_child(inst)
		inst.set_item(i.icon, i.amount)
	
	$Boundings/Body/Output/OutputBox.set_item(recipe.outputItem.icon, recipe.outputItem.amount)

func _input(event):
	if key == "" : return
	if current_recipe == null : return
	
	if visible and event.is_action_pressed(key):
		keyPressed.emit(self)
