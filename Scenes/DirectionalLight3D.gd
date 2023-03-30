@tool
extends DirectionalLight3D

@export var speed : float = 0.005

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	rotation.x += speed * 0.1
