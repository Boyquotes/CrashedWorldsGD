extends Area3D

func _on_body_entered(body:Node3D) -> void:
	if body.is_in_group("player"):
		#check inventory
		var inventory: GridContainer = body.get_node("Inventory/Bag")
		var itemCounter = 0

		for i in inventory.get_children():
			if i.itemHolding == null:
				continue
			else:
				var item: Item = i.itemHolding
				#TODO: Check itemName = "Motherboard", quantity = 5
				if item.itemName == "Grassy Stone Bloc":
					itemCounter += item.amount

		$Label.show()

		if itemCounter >= 3:
			$Label.text = "You escaped!"
			#get_tree().change_scene("res://Scenes/WinScreen.tscn")
		else:
			$Label.text = "You need 3 Grassy Stone Blocs to escape! Current amount: " + str(itemCounter)

		await get_tree().create_timer(3.0).timeout
		$Label.hide()
