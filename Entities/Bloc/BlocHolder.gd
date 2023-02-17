extends Sprite3D

@export var item : Item

func _ready():
	texture = item.icon

func use():
	pass
