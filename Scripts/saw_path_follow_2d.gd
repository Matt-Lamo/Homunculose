extends PathFollow2D

@export var speed = 0.75

func _process(delta: float) -> void:
	progress_ratio += delta * speed
