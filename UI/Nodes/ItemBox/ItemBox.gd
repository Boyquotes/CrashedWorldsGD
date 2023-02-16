extends MarginContainer

func set_item(icon : Texture2D, quantity : int):
	$Body/Icon.texture = icon
	$Body/Quantity.text = str(quantity)
