extends PathFollow2D

var speed = 0.5


func _process(delta: float) -> void:
	progress_ratio += delta * speed
