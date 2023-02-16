extends Node3D

func _input(event):
	if event.is_action_pressed("Interact"):
		$Wolf/SubViewport/Node2D.calculate_hue()
		random_terrain()

func _ready():
	random_terrain()

func random_terrain():
	$GridMap.clear()
	
	var noise = FastNoiseLite.new()
	noise.seed = randi()
	noise.fractal_gain = 6
	noise.fractal_octaves = 8
	noise.fractal_lacunarity = 1.25
	
	var count : int = 0
	var starttime = Time.get_ticks_msec()
	
	for i in range(-256,256):
		for j in range(-256,256):
			var greyvalue : float = noise.get_noise_2d(i,j)
			var id : int = 0
			var y : int = 0
			
			if greyvalue < 0.25 : id = 0
			elif greyvalue >= 0.25 and greyvalue < 0.5: id = 1 ; y = 1
			elif greyvalue >= 0.5 and greyvalue < 0.75: id = 2; y = 2
			elif greyvalue >= 0.75 and greyvalue < 0.95: id = 3 ; y = 3
			elif greyvalue >= 0.95 : id = 4
			$GridMap.set_cell_item(Vector3i(i,y,j), id)
			for x in y:
				$GridMap.set_cell_item(Vector3i(i,x,j), id)
				
				
			count += 1
	
	var endtime = Time.get_ticks_msec() - starttime
	print("Placed " + str(count) + " blocs in " + str(endtime) + "ms")
