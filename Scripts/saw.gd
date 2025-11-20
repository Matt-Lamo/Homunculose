extends Area2D
@export var direction = ""
signal playerContact()

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



func _on_body_entered(body: Node2D) -> void:
	if body.name == "Homunculus":
		playerContact.emit()
