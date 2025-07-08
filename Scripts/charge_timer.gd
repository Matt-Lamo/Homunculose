extends Timer


func _ready() -> void:
	wait_time = Global.chargeTimer



func _on_timeout() -> void:
	Global.charge = Global.charge - 1.0
