extends RayCast2D
var collider


func _ready() -> void:
	pass # Replace with function body.



func _process(delta: float) -> void:
	if is_colliding():
		collider = get_collider().name
		#print(collider)
