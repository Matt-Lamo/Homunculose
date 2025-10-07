extends Node2D

var levelGenerated = false
@onready var loadingScreen = $HUD/LoadingScreen
const cellSpace = 512
@onready var levelGrid = [[],[]]
const xSize = 5
const ySize = 5
func _ready() -> void:
	loadingScreen.visible = false

func _process(delta: float) -> void:
	if !levelGenerated:
		loadingScreen.visible = true
	else:
		loadingScreen.visible = false

func generate_solution_path() -> void:
	pass
	
func apply_level_cells() -> void:
	pass
	
func generate_grid() -> void:
	for i in xSize:
		for j in ySize:
			levelGrid[i][j]=null
