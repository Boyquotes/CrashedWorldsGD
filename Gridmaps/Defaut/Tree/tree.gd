extends Node3D

# ------------------------------------------------------------------------------ PUBLIC PROPERTIES
@export var leaf_material : BaseMaterial3D
@export var lootable : Lootable
@export var life : int = 3
# ------------------------------------------------------------------------------ PRIVATE PROPERTIES

# ------------------------------------------------------------------------------ BASIC METHODS

func loot() : 
	life -= 1
	if life > 0: return []
	queue_free()
	return lootable.dropLoot()

func _ready():
	randomize()
	var noise = leaf_material.albedo_texture as NoiseTexture2D
	noise.noise.seed = randi()
	var color
	var hue = randf_range(0.0 ,0.9)
	var sat = 0.5
	var val = randf_range(0.0,0.2)
		
	for i in range(0,3):
		color = Color.from_hsv(hue, sat, val)
		noise.color_ramp.set_color(i, color)
		hue += randf_range(0.0,0.05)
		sat += randf_range(-0.3,0.3)
		val += i * 0.5
		
	$Leaves.material_override = leaf_material
	
	rotation_degrees.y = randf_range(0.0,360.0)
	var randscale = randf_range(0.8,1.2)
	scale = Vector3(randscale, randscale, randscale)


# ------------------------------------------------------------------------------ CUSTOM METHODS

# ------------------------------------------------------------------------------ SIGNALS


