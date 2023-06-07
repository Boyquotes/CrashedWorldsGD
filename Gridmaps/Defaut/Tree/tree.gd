extends Node3D

# ------------------------------------------------------------------------------ PUBLIC PROPERTIES
@export var leaf_material : BaseMaterial3D
# ------------------------------------------------------------------------------ PRIVATE PROPERTIES

# ------------------------------------------------------------------------------ BASIC METHODS

func _input(event):
	if event.is_action_pressed("ui_left"):
		var noise = leaf_material.albedo_texture as NoiseTexture2D
		noise.noise.seed = randi()
		var color
		var hue = randf_range(0.0 ,0.4)
		var sat = randf_range(0.1 ,0.5)
		var val = randf_range(0.0,0.2)
		
		for i in range(0,3):
			color = Color.from_hsv(hue, sat, val)
			noise.color_ramp.set_color(i, color)
			hue += randf_range(0.0,0.1)
			sat += 0.3
			val += i * 0.4
		
		$Leaves.material_override = leaf_material

func _ready():
	randomize()
	var noise = leaf_material.albedo_texture as NoiseTexture2D
	
	var color
	var hue = randf_range(0.2,1)
	var sat = randf_range(0,0.8)
	var val = randf_range(0.2,1)
	
	for i in range(0,2):
		color = Color.from_hsv(hue, sat, val)
		noise.color_ramp.set_color(i, color)
		hue -= 0.1
		sat += 0.1
		val -= 0.1 
	
	$Leaves.material_override = leaf_material


# ------------------------------------------------------------------------------ CUSTOM METHODS

# ------------------------------------------------------------------------------ SIGNALS


