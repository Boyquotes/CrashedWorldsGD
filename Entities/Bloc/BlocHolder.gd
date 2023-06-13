extends Sprite3D

@export var item : ItemHolder

func _ready():
	texture = item.item.icon

func use():
	item.quantity -= 1
