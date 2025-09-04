extends Area2D

@export var direction = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	match direction:
		"bottom":
			rotation_degrees = 0
		"top":
			rotation_degrees = 180
		"left":
			rotation_degrees = 90
		"right":
			rotation_degrees = 270
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
