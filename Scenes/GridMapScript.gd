extends GridMap

enum Block {
	Grass = 0,
	Dirt,
	Stone,
	StoneGrass,
	Sand,
	Berries
}

func _ready() -> void:
	randomize()
	random_terrain()

func random_terrain():
	self.clear()
	var size: int = 256
	setGridMapCells(size)
	generateBerryBushes(0.05)


#set the blocks for the grid map
func setGridMapCells(size: int):
	var count : int = 0
	var starttime = Time.get_ticks_msec()

	var noiseMap = getNoiseMap(size)

	for x in range(size):
		for y in range(size):
			count+=1
			var noiseHeight = noiseMap[x][y]
			set_cell_item(Vector3i(x,0,y), Block.Sand)
			if noiseHeight >= 1.6:
				set_cell_item(Vector3i(x,1,y), Block.Grass)
				count+=1
			if noiseHeight >= 2.8:
				set_cell_item(Vector3i(x,2,y), Block.Stone)
				count+=1
			if noiseHeight >= 3.6:
				set_cell_item(Vector3i(x,3,y), Block.StoneGrass)
				count+=1
	setOuterSand()

	var endtime = Time.get_ticks_msec() - starttime
	print("Placed " + str(count) + " blocs in " + str(endtime) + "ms")

#create a noiseMap with range from (0-1)
func getNoiseMap(size: int):
	var noiseMap = []
	#self.set_meta("NoiseColorMap.seed", randi())
	var noise = self.get_meta("NoiseColorMap").noise
	var maxNoiseHeight:float = -1
	var minNoiseHeight:float = 1

	for i in range(size):
		noiseMap.append([])
		for j in range(size):
			var noiseHeight: float = noise.get_noise_2d(i,j)
			if noiseHeight > maxNoiseHeight:
				maxNoiseHeight = noiseHeight
			elif noiseHeight < minNoiseHeight:
				minNoiseHeight = noiseHeight

			noiseMap[i].append(noiseHeight)

	for x in range(size):
		for y in range(size):
			noiseMap[x][y] = inverse_lerp(minNoiseHeight, maxNoiseHeight, noiseMap[x][y])*4

	return noiseMap

#turn the blocks next to the the sea into sand
func setOuterSand():
	var cells = self.get_used_cells()
	for cellCoord in cells:
		if cellCoord.y == 1:
			for i in range(cellCoord.x - 1, cellCoord.x + 2):
				for j in range(cellCoord.z - 1, cellCoord.z + 2):
					var neighborCell = Vector3i(i, cellCoord.y, j)
					if get_cell_item(neighborCell) == self.INVALID_CELL_ITEM:
						set_cell_item(cellCoord, Block.Sand)
						break

#generate berry bushes
func generateBerryBushes(percentage: float):
	var grounds = self.get_used_cells_by_item(Block.Grass)
	grounds = grounds.filter(upperIsNotStoneBlock)
	grounds.shuffle()
	for i in range(grounds.size() * percentage):
		set_cell_item(grounds[i] + Vector3i.UP, Block.Berries)

func upperIsNotStoneBlock(grassCoord) -> bool:
	var upperStoneCell = grassCoord + Vector3i.UP
	return get_cell_item(upperStoneCell) == INVALID_CELL_ITEM

func get_heighest_cell(x: int, z: int) -> int:
	for y in range(3, 0, -1):
		print(Vector3i(x,y,z))
		print(get_cell_item(Vector3i(x,y,z)))
		var pos = local_to_map(Vector3i(x,y,z))
		print(pos)
		if get_cell_item(pos) != INVALID_CELL_ITEM:
			return y
	return 3

