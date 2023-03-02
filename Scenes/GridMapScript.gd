extends GridMap

enum Block {
	Grass = 0,
	Dirt,
	Stone,
	StoneGrass,
	Sand,
	Berries
}

func random_terrain():
	self.clear()
		
	var size: int = 256
			
	setGridMapCells(size)
	generateBerryBushes()

#set the blocks for the grid map (getNoiseMap + 
func setGridMapCells(size: int):
	var count : int = 0
	var starttime = Time.get_ticks_msec()
	
	var noiseMap = getNoiseMap(size)
	
	for x in range(size):
		for y in range(size):
			count+=1
			var id = Block.Sand
			var noiseHeight = noiseMap[x][y]
			self.set_cell_item(Vector3i(x,0,y), Block.Sand)
			if noiseHeight >= 1.6: 
				self.set_cell_item(Vector3i(x,1,y), Block.Grass)
				count+=1
			if noiseHeight >= 2.8: 
				self.set_cell_item(Vector3i(x,2,y), Block.Stone)
				count+=1
			if noiseHeight >= 3.6:
				self.set_cell_item(Vector3i(x,3,y), Block.StoneGrass)
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
	
func setOuterSand():
	var cells = self.get_used_cells()
	for cellCoord in cells:
		if cellCoord.y == 1:
			for i in range(cellCoord.x - 1, cellCoord.x + 2):
				for j in range(cellCoord.z - 1, cellCoord.z + 2):
					var neighborCell = Vector3i(i, cellCoord.y, j)
					if self.get_cell_item(neighborCell) == self.INVALID_CELL_ITEM:
						self.set_cell_item(cellCoord, Block.Sand)
						break

func generateBerryBushes():
	var grounds = self.get_used_cells_by_item(Block.Grass)
	grounds = grounds.filter(checkUpperStoneBlock)
	randomize()
	grounds.shuffle()
	for i in range(grounds.size() * 0.2):
		self.set_cell_item(grounds[i] + Vector3i.UP, Block.Berries)
	
func checkUpperStoneBlock(grassCoord):
	var upperStoneCell = grassCoord + Vector3i.UP
	return self.get_cell_item(upperStoneCell) == self.INVALID_CELL_ITEM
	
