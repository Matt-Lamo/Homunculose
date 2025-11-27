extends Path2D
@export var direction = ""
@export var start_progress_ratio = 0.0
@onready var saw = $PathFollow2D/Saw
@onready var pathFollow2d = $PathFollow2D

func _ready() -> void:
	saw.direction = direction
	pathFollow2d.progress_ratio = start_progress_ratio
	
