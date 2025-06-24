extends ProgressBar


func _ready() -> void:
	min_value = 0.0
	max_value = Global.maxCharge
	value = Global.maxCharge
	
func _process(delta: float) -> void:
	max_value = Global.maxCharge
	value = Global.charge
	
