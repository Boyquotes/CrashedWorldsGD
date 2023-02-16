extends MarginContainer


func set_item(icon : Texture2D, description : String):
	$Boundings/VBoxContainer/Icon.texture = icon
	$Boundings/VBoxContainer/Description.text = description
