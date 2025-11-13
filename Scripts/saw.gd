extends Area2D
@export var direction = ""


func _process(delta: float) -> void:
	match direction:
		"bottom":
			rotation_degrees = 0
		"top":
			rotation_degrees = 180
		"left":
			rotation_degrees = 90
		"right":
			rotation_degrees = 270
