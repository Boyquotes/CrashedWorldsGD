extends TextureButton

signal onPressed
var itemHolding = null

func _on_pressed():
	onPressed.emit(self)
