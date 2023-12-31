extends Node3D

@onready var item_scene = preload("res://Entities/ItemDrop/ItemDrop.tscn")

@export var spawned_items: Array[ItemHolder]
@export var item_amount: int

@export var spawned_ai: Array[PackedScene]
@export var ai_amount: int
@export var spawned_objects: Array[PackedScene]
@export var object_amount: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_parent().ready
	spawn_objects()
	spawn_items()
	spawn_creatures()

func spawn_creatures() -> void:
	for scene in spawned_ai:
		for i in range(ai_amount):
			var wolf_scene = scene
			var wolf: CharacterBody3D = wolf_scene.instantiate()
			wolf.position = create_random_position()
			wolf.scale = Vector3(2.5,2.5,2.5)
			add_child(wolf)
			#print("ai pos: "+ str(wolf.position))
			

func spawn_objects() -> void:
	for scene in spawned_objects:
		for i in range(object_amount):
			var object = scene.instantiate()
			add_child(object)
			object.global_position = create_random_position()
			object.scale = Vector3(1,1,1)
			
			#print("globalpos: "+ str(object.global_position))

func spawn_items() -> void:
	for item in spawned_items:
		for i in range(item_amount):
			var item_drop: ItemDrop = item_scene.instantiate()
			item_drop.item = item
			item_drop.scale = Vector3(2.5,2.5,2.5)
			add_child(item_drop)
			item_drop.global_position = create_random_position(55,60)
			#print("globalpos of item: "+ str(item_drop.global_position))

func create_random_position(min_range: int = 0, max_range: int = 256) -> Vector3:
	var x = randi_range(min_range, max_range)
	var z = randi_range(min_range, max_range)
	var y: int = get_parent().get_heighest_cell(x, z)
	return Vector3(x, y + 1.1, z)
