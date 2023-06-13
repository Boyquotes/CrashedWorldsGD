extends Node3D

@export var item : ItemHolder

func use():
	$AnimationPlayer.play("Dig")
