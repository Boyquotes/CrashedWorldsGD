extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	calculate_hue()

func flip(isFlip:bool):
	for i in get_children():
		i.flip_h = isFlip

func calculate_hue() -> void :
		
	# HSV generation.
	var hue : float = randf_range(0,1)
	var sat : float = 0
	var val : float = 0
	
	# Each parts has a shader that take into account 8 colors.
	# We'll generate them and put them in an array to share among all of the child parts.
	var colors = []
	
	# Palette generation.
	# We increase hue, saturation and value for interesting results.
	# Then, we add the new color to the array.
	for j in range(0,9):
		colors.append(Color.from_hsv(hue,sat,val))
		hue = fmod(hue + randf_range(0.0,0.1), 1.0)
		sat = clamp(fmod(sat + randf_range(0.075,0.15), 1.0),0.3,0.8)
		val = clamp(fmod(val + randf_range(0.075,0.15), 1.0),0.3,0.7)
		
	
	for i in get_children(): # For each child
		for j in range(0,9):
			i.material.set_shader_parameter("color" + str(j), colors[j])
