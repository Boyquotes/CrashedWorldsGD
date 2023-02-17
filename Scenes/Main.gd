extends Node3D

enum Block {
	Grass = 0,
	Dirt,
	Stone,
	StoneGrass,
	Sand
}

func _input(event):
	if event.is_action_pressed("Interact"):
		$Wolf/SubViewport/Node2D.calculate_hue()
		random_terrain()

func _ready():
	random_terrain()
	$CharacterBody3D.connect("destroyGrid", destroyGrid)

func random_terrain():
	$GridMap.clear()
	var noise = $GridMap.get_meta("NoiseColorMap").noise
	
	var count : int = 0
	var starttime = Time.get_ticks_msec()
	
	var size: int = 128
	var noiseMap = []
	
	var maxNoiseHeight:float = -1
	var minNoiseHeight:float = 1
	
	for i in range(size):
		noiseMap.append([])
		#noiseMap.resize(size)
		for j in range(size):
			var noiseHeight: float = noise.get_noise_2d(i,j)
			if noiseHeight > maxNoiseHeight:
				maxNoiseHeight = noiseHeight
			elif noiseHeight < minNoiseHeight:
				minNoiseHeight = noiseHeight
			
			noiseMap[i].append(noiseHeight)
			
	for x in range(size):
		for y in range(size):
			noiseMap[x][y] = inverse_lerp(minNoiseHeight, maxNoiseHeight, noiseMap[x][y])

			var id: int = 0
			var height: int = 0
			var noiseHeight = noiseMap[x][y]
			if noiseHeight < 0.4 : id = Block.Sand
			elif noiseHeight >= 0.4 and noiseHeight < 0.75: 
				id = Block.Grass ; height = 1
				$GridMap.set_cell_item(Vector3i(x,0,y), Block.Sand)
			elif noiseHeight >= 0.75 and noiseHeight < 0.9: 
				id = Block.Stone; height = 2
				$GridMap.set_cell_item(Vector3i(x,0,y), Block.Sand)
				$GridMap.set_cell_item(Vector3i(x,1,y), Block.Grass)
			
			elif noiseHeight >= 0.9: id = Block.StoneGrass ; height = 3
			$GridMap.set_cell_item(Vector3i(x,height,y), id)
	
	var cells = $GridMap.get_used_cells()
	for cellCoord in cells:
		if cellCoord.y == 1:
			for i in range(cellCoord.x - 1, cellCoord.x + 2):
				for j in range(cellCoord.z - 1, cellCoord.z + 2):
					var neighborCell = Vector3i(i, cellCoord.y, j)
					if $GridMap.get_cell_item(neighborCell) == $GridMap.INVALID_CELL_ITEM:
						$GridMap.set_cell_item(cellCoord, Block.Sand)
						break
	
	var endtime = Time.get_ticks_msec() - starttime
	print("Placed " + str(count) + " blocs in " + str(endtime) + "ms")
	
	
func destroyGrid(pos: Vector3i):
	print(pos)
	print($GridMap.get_cell_item(pos))
	$GridMap.set_cell_item(pos, $GridMap.INVALID_CELL_ITEM)
