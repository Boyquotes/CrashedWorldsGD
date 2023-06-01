extends Node3D


@export var spawned_items: Array[Item]
@export var spawned_ai: Array[PackedScene]
@export var spawned_objects: Array[PackedScene]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_parent().ready
	spawn_objects()
	spawn_items()
	spawn_creatures()

func spawn_creatures(amount: int = 200) -> void:
	for scene in spawned_ai:
		for i in range(amount):
			var wolf_scene = scene
			var wolf: CharacterBody3D = wolf_scene.instantiate()
			wolf.position = create_random_position()
			wolf.scale = Vector3(2.5,2.5,2.5)
			add_child(wolf)
			print("ai pos: "+ str(wolf.position))

func spawn_objects(amount: int = 200) -> void:
	for scene in spawned_objects:
		for i in range(amount):
			var object = scene.instantiate()
			object.global_position = create_random_position()
			object.scale = Vector3(2.5,2.5,2.5)
			add_child(object)
			print("globalpos: "+ str(object.global_position))

func spawn_items(amount: int = 200) -> void:
	var item_scene = preload("res://Entities/ItemDrop/ItemDrop.tscn")
	for item in spawned_items:
		for i in range(amount):
			var item_drop: ItemDrop = item_scene.instantiate()
			item_drop.item = item
			item_drop.scale = Vector3(2.5,2.5,2.5)
			item_drop.global_position = create_random_position(50,70)
			add_child(item_drop)
			print("globalpos of item: "+ str(item_drop.global_position))

func create_random_position(min_range: int = 0, max_range: int = 256) -> Vector3:
	var x = randi_range(min_range, max_range)
	var z = randi_range(min_range, max_range)
	var y: int = get_parent().get_heighest_cell(x, z)
	return Vector3(x, y + 1, z)