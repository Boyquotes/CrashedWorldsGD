extends MarginContainer

signal recipeClicked

var current_recipe : Recipe = null

@onready var itembox = load("res://UI/Nodes/ItemBox/ItemBox.tscn")

func set_recipe(recipe : Recipe):
	
	for i in $Boundings/Body/Inputs.get_children():
		i.queue_free()
	
	current_recipe = recipe
	for i in recipe.inputItems:
		i = i as ItemHolder
		var inst = itembox.instantiate()
		$Boundings/Body/Inputs.add_child(inst)
		inst.set_item(i.item.icon, i.quantity)
	
	$Boundings/Body/Output/OutputBox.set_item(recipe.outputItem.item.icon, recipe.outputItem.item.description)


# upload recipe
func _on_button_pressed():
	recipeClicked.emit(current_recipe)
