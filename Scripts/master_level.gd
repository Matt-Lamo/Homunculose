extends Node2D

var levelGenerated = false
@onready var loadingScreen = $HUD/LoadingScreen
const cellSpace = 512
@onready var levelGrid = [] #5 by 5 grid
@onready var solutionPath = []
const xSize = 5
const ySize = 5
var rng = RandomNumberGenerator.new()

func _ready() -> void:
	randomize()
	loadingScreen.visible = false
	generate_grid()
	generate_solution_path()

func _process(delta: float) -> void:
	if !levelGenerated:
		loadingScreen.visible = true
	else:
		loadingScreen.visible = false

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
	pass
	
func generate_grid() -> void:
	for i in xSize:
		levelGrid.append([])
		for j in ySize:
			levelGrid[i].append(j)
	print(levelGrid)
