extends GridMap

@export var wolf_scene: PackedScene

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
# 	spawnCreatures(size)


# func spawnCreatures(map_size: int, amount: int = 200) -> void:
# 	for i in range(amount):
# 		var wolf: CharacterBody3D = wolf_scene.instantiate()
# 		wolf.position = Vector3(randf_range(0, map_size), 5, randf_range(0,map_size))
# 		wolf.scale = Vector3(2.5,2.5,2.5)
# 		get_parent().add_child(wolf)

#set the blocks for the grid map (getNoiseMap +
func setGridMapCells(size: int):
	var count : int = 0
	var starttime = Time.get_ticks_msec()

	var noiseMap = getNoiseMap(size)

	for x in range(size):
		for y in range(size):
			count+=1
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

#turn the blocks next to the the sea into sand
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

#generate berry bushes
func generateBerryBushes(percentage: float = 0.1):
	var grounds = self.get_used_cells_by_item(Block.Grass)
	grounds = grounds.filter(checkUpperStoneBlock)

	grounds.shuffle()
	for i in range(grounds.size() * percentage):
		self.set_cell_item(grounds[i] + Vector3i.UP, Block.Berries)

func checkUpperStoneBlock(grassCoord):
	var upperStoneCell = grassCoord + Vector3i.UP
	return self.get_cell_item(upperStoneCell) == self.INVALID_CELL_ITEM



