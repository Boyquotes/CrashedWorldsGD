extends CanvasLayer

func _ready():
	for i in $Bag.get_children():
		i.connect("onPressed", _on_button_pressed)

func _on_button_pressed(button):
	if button.itemHolding == null:
		$ItemList.show()
		$ItemList.global_position = button.global_position + Vector2(55,0)

func _unhandled_input(event):
	if event.is_action_pressed("RMB"):
		$ItemList.hide()
