extends Node3D

@export var item : Item

func use():
	$AnimationPlayer.play("Dig")

