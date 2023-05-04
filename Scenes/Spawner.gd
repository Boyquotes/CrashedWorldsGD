extends Node3D

@export var spawned_items: Array[PackedScene]
@export var spawned_ai: Array[PackedScene]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_parent().ready
	spawn_objects()
	spawn_creatures()

func spawn_creatures(map_size: int = 256, amount: int = 200) -> void:
	for scene in spawned_ai:
		for i in range(amount):
			var wolf_scene = scene
			var wolf: CharacterBody3D = wolf_scene.instantiate()
			wolf.position = Vector3(randf_range(0, map_size), 5, randf_range(0, map_size))
			wolf.scale = Vector3(2.5,2.5,2.5)
			add_child(wolf)
			print("ai pos: "+ str(wolf.position))

func spawn_objects(map_size: int = 256, amount: int = 200) -> void:
	for scene in spawned_items:
		for i in range(amount):
			var object = scene.instantiate()
			var x = randi_range(0, map_size)
			var z = randi_range(0, map_size)
			var y: int = get_parent().get_heighest_cell(x, z)
			object.global_position = Vector3(x, y + 1, z)
			add_child(object)
			print("globalpos: "+ str(object.global_position))
