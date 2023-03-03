extends Node3D

@export_group("Item")
@export var item : Item

@export_group("Custom Properties")
@export var damage : int = 1

func _ready():
	$Sprite3D.texture = item.icon

func use():
	$AnimationPlayer.play("Attack")


func _on_area_3d_body_entered(body):
	if "Stats" in body:
		body.Stats.damage(damage)

