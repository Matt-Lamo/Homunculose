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
			
			if solutionPath.has([i,j]): #if grid location is part of the solution path...
				for iter in range(0,solutionPath.size()-1): #gets index of element in solutionPath
					if solutionPath[iter] == [i,j]:
						index = iter
						break
						
					if index == 0: #if position is on starting room
						var nextCell = solutionPath[1]
						if nextCell[1] > solutionPath[index][1]: #next cell is to right of starting room
							#pass #INSERT ROOM FROM StartingRooms_R (right room)
							applyCellRandom("Starting_Rooms/R",i,j)

						elif nextCell[1] < solutionPath[index][1]: #next cell is to left of starting room
							#pass #INSERT ROOM FROM StartingRooms_L (left room)
							applyCellRandom("Starting_Rooms/L",i,j)
							
						else:  #if nextCell[0] > solutionPath[index][0]: next cell has to be below
							#pass #INSERT ROOM FROM StartingRooms_B (bottom room)
							applyCellRandom("Starting_Rooms/B",i,j)
							
					elif index == solutionPath.size()-1: #if position is on final room
						pass
						var previousCell = solutionPath[-2]
						if previousCell[0] > solutionPath[index][0]:
							pass #INSERT ROOM FROM FinalRoom_R (right room)
						elif previousCell[0] < solutionPath[index][0]:
							pass #INSERT ROOM FROM FinalRoom_L (left room)
						elif previousCell[1] < solutionPath[index][1]:
							pass #INSERT ROOM FROM FinalRoom_T (top room)
					else: #if position is any other room
						var nextCell = solutionPath[index+1]
						var previousCell = solutionPath[index-1]
						var doorType = ["",""]
						#PREVIOUS CELL
						if previousCell[0] < solutionPath[index][0]:
							doorType[0] = "L"
						elif previousCell[0] > solutionPath[index][0]:
							doorType[0] = "R"
						elif previousCell[1] < solutionPath[index][1]:
							doorType[0] = "T"
						#NEXT CELL
						if nextCell[0] < solutionPath[index][0]:
							doorType[1] = "L"
						elif previousCell[0] > solutionPath[index][0]:
							doorType[1] = "R"
						elif nextCell[1] > solutionPath[index][1]:
							doorType[1] = "B"
							
						if doorType.has("B") and doorType.has("L"):
							print("BL")
							applyCellRandom("BL",i,j)
						elif doorType.has("L") and doorType.has("R"):
							print("LR")
							applyCellRandom("LR",i,j)
						elif doorType.has("L") and doorType.has("T"):
							print("LT")
							applyCellRandom("LT",i,j)
						elif doorType.has("R") and doorType.has("B"):
							print("RB")
							applyCellRandom("RB",i,j)
						elif doorType.has("T") and doorType.has("B"):
							print("TB")
							applyCellRandom("TB",i,j)
						elif doorType.has("T") and doorType.has("R"):
							print("TR")
							applyCellRandom("TR",i,j)
						
					
			else:
				levelGrid[i][j] = load("res://Scenes/Level_Cells/demo_fill.tscn")
				levelGrid[i][j]=levelGrid[i][j].instantiate()
				add_child(levelGrid[i][j])
				levelGrid[i][j].position = Vector2((i*cellSpace),(j*cellSpace))
	
func generate_grid() -> void:
	for i in xSize:
		levelGrid.append([])
		for j in ySize:
			levelGrid[i].append(j)
	print(levelGrid)
	
func applyCellRandom(cellType,x,y):
	print("applyCellRandom CALLED " + cellType + " " + str(x) + str(y))
	var files = ResourceLoader.list_directory("res://Scenes/Level_Cells/"+str(cellType))
	
	var randomCellPath = "res://Scenes/Level_Cells/"+cellType + "/" + files[rng.randi_range(0,files.size()-1)]
	print(randomCellPath)
	levelGrid[x][y] = load(randomCellPath)
	levelGrid[x][y] = levelGrid[x][y].instantiate()
	levelGrid[x][y].position = Vector2(cellSpace*x,cellSpace*y)
	add_child(levelGrid[x][y])
	levelGrid[x][y].reparent(levelNode)
	
	
