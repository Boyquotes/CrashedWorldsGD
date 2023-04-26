extends Node3D

@export var spawned_scenes: Array[PackedScene]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_objects()

func spawn_creatures(map_size: int, amount: int = 200) -> void:
	for scene in spawned_scenes:
		for i in range(amount):
			var wolf_scene = scene
			var wolf: CharacterBody3D = wolf_scene.instantiate()
			wolf.position = Vector3(randf_range(0, map_size), 5, randf_range(0,map_size))
			wolf.scale = Vector3(2.5,2.5,2.5)
			add_child(wolf)

func spawn_objects() -> void:
	for scene in spawned_scenes:
		var object = scene.instantiate()
		var y: int = get_parent().get_heighest_cell(60,60)
		object.global_position = Vector3(60, y,60)
		add_child(object)
		print(object.global_position)
