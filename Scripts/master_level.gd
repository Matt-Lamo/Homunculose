extends Node2D

var levelGenerated = false
@onready var loadingScreen = $HUD/LoadingScreen
const cellSpace = 512
@onready var levelGrid = [] #5 by 5 grid
@onready var solutionPath = []
const xSize = 5
const ySize = 5
var rng = RandomNumberGenerator.new()
@onready var levelNode = $Level

func _ready() -> void:
	randomize()
	loadingScreen.visible = true
	generate_grid()
	generate_solution_path()
	apply_level_cells()
	levelGenerated = true

func _process(delta: float) -> void:
	if !levelGenerated:
		loadingScreen.visible = false
	else:
		loadingScreen.visible = true

func generate_solution_path() -> void:
	var position = [0,0]
	position = [rng.randi_range(0,4),0]
	solutionPath.append([position[0],position[1]])
	while(solutionPath[-1] != [4,4] or solutionPath[-1] != [0,4]):
		if(solutionPath[-1] == [4,4] or solutionPath[-1] == [0,4]):
			break
		#print("loop")
		var checkValid = false
		var directionOptions = ["left", "right","down"]
		while !checkValid and directionOptions.size()>0:
			
			var randIndex = rng.randi_range(0,directionOptions.size()-1)
			var randDirection = directionOptions[randIndex]
			match randDirection:
				"left":
					if position[0]-1 >= 0 and !(solutionPath.has([position[0]-1,position[1]])): #checks cell is included in grid and not occupied already 
						checkValid = true
						position[0] -= 1
						solutionPath.append([position[0],position[1]])
						print(solutionPath)
					else:
						#print("left failed")
						directionOptions.remove_at(randIndex)
				"down":
					if position[1]+1 <=4 and !(solutionPath.has([position[0],position[1]+1])): #checks cell is included in grid and not occupied already
						checkValid = true
						position[1] += 1
						solutionPath.append([position[0],position[1]])
						print(solutionPath)
					else:
						#print("right failed")
						directionOptions.remove_at(randIndex)
				"right":
					if position[0]+1 <= 4  and !(solutionPath.has([position[0]+1,position[1]])):
						checkValid = true
						position[0] += 1
						solutionPath.append([position[0],position[1]])
						print(solutionPath)
					else:
						#print("down failed")
						directionOptions.remove_at(randIndex)
	print(solutionPath)
		
		
	
func apply_level_cells() -> void:
	var index = 0
	for i in range(levelGrid.size()):
		for j in range(levelGrid[0].size()):
			if !solutionPath.has([i,j]): #if grid location is NOT part of the solution path...
				levelGrid[i][j] = load("res://Scenes/Level_Cells/demo_fill.tscn")
				levelGrid[i][j]=levelGrid[i][j].instantiate()
				add_child(levelGrid[i][j])
				levelGrid[i][j].position = Vector2((i*cellSpace),(j*cellSpace))
	for i in range(0,solutionPath.size()-1):
		var currentCell = solutionPath[i]
		if i == 0: #starting room
			var nextCell = solutionPath[1]
			if nextCell[0] > solutionPath[i][0]: #next room is to the right
				applyCellRandom("Starting_Rooms/R/",currentCell[0],currentCell[1])
			elif nextCell[0] < solutionPath[i][0]: #next room is to the left
				applyCellRandom("Starting_Rooms/L/",currentCell[0],currentCell[1])
			else: #next room has to be below
				applyCellRandom("Starting_Rooms/B/",currentCell[0],currentCell[1])
		elif i == solutionPath.size()-1: #end room
			pass
		else: #all other rooms
			var nextCell = solutionPath[i+1]
			var previousCell = solutionPath[i-1]
			var cellType = ""
			#next Cell
			if nextCell[0] > solutionPath[i][0]: #next room is to the right
				cellType = cellType + "R"
			elif nextCell[0] < solutionPath[i][0]: #next room is to the left
				cellType = cellType + "L"
			else: #next room has to be below
				cellType = cellType + "B"
			#previous Cell
			if previousCell[0] > solutionPath[i][0]: #previous room is to the right
				cellType = cellType + "R"
			if previousCell[0] < solutionPath[i][0]: #previous room is to the left
				cellType = cellType + "L"
			else: #next room has to be above
				cellType = cellType + "T"
			if "B" in cellType and "L" in cellType:
				applyCellRandom("BL/",currentCell[0],currentCell[1])
			elif "L" in cellType and "R" in cellType:
				applyCellRandom("LR/",currentCell[0],currentCell[1])
			elif "L" in cellType and "T" in cellType:
				applyCellRandom("LT/",currentCell[0],currentCell[1])
			elif "R" in cellType and "B" in cellType:
				applyCellRandom("RB/",currentCell[0],currentCell[1])
			elif "T" in cellType and "B" in cellType:
				applyCellRandom("TB/",currentCell[0],currentCell[1])
			elif "T" in cellType and "R" in cellType:
				applyCellRandom("TR/",currentCell[0],currentCell[1])
				
			
			
			
	
func generate_grid() -> void:
	for i in xSize:
		levelGrid.append([])
		for j in ySize:
			levelGrid[i].append(j)
	print(levelGrid)
	
func applyCellRandom(cellType,x,y):
	print("applyCellRandom CALLED " + cellType + " " + str(x) + str(y))
	var files = ResourceLoader.list_directory("res://Scenes/Level_Cells/"+str(cellType))
	
	var randomCellPath = "res://Scenes/Level_Cells/"+cellType + files[rng.randi_range(0,files.size()-1)]
	print(randomCellPath)
	levelGrid[x][y] = load(randomCellPath)
	levelGrid[x][y] = levelGrid[x][y].instantiate()
	levelGrid[x][y].position = Vector2(cellSpace*x,cellSpace*y)
	add_child(levelGrid[x][y])
	levelGrid[x][y].reparent(levelNode)
	
	
