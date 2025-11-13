extends Node2D

@onready var line2d = $Line2D
@onready var rayCast2d = $RayCast2D
@export var length = 0

func _ready() -> void:
	rayCast2d.target_position.y = 0 + length
	line2d.set_point_position(1,Vector2(0,length))
