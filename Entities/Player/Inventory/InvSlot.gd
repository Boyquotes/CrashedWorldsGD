extends TextureRect
class_name InventorySlot

signal onPressed
signal onMouseHover
signal onMouseLeft
signal equipedItem

@export var isEquipSlot : bool = false

var itemHolding: ItemHolder = null:
	set(value):
		itemHolding = value
		_on_item_changed(value)
		
	get : return itemHolding

func _process(_delta):
	if itemHolding != null:
		%Quantity.text = str(itemHolding.quantity)
	else:
		%Quantity.text = ""

func _on_item_changed(item: ItemHolder):
	$InvSlot.show()
	$Quantity.show()
	if item != null:
		update_icons(item.item.icon)
		%Quantity.text = str(item.quantity)
		%InvSlot.tooltip_text = item.item.description
		self_modulate = Color.GRAY
	else:
		update_icons(null)
		%Quantity.text = ""
		%InvSlot.tooltip_text = ""
		self_modulate = Color.WHITE
	
	if isEquipSlot:
		equipedItem.emit(item)

func update_icons(tex : Texture):
	%InvSlot.texture_normal = tex
	%InvSlot.texture_pressed = tex
	%InvSlot.texture_hover = tex
	%InvSlot.texture_disabled = tex
	%InvSlot.texture_focused = tex
	

func _on_inv_slot_pressed():
	onPressed.emit(self)

func _on_mouse_exited():
	onMouseLeft.emit(self)

func _on_inv_slot_gui_input(_event):
#	onMouseHover.emit(self)
	pass

func _on_inv_slot_mouse_entered():
	onMouseHover.emit(self)
