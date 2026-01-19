extends Camera2D

@export var randomStrength: float = 5.0
@export var shakeFade: float = 5.0

var shakeApplied: bool = false

var rng= RandomNumberGenerator.new()
var shake_strength: float = 0.0

func _ready() -> void:
	rng.randomize()
	
func apply_shake():
	shake_strength = randomStrength
	
func _process(delta: float) -> void:
	
	if shakeApplied:
		apply_shake()
		shakeApplied = false
		
	print(shake_strength)
	
	if shake_strength > 0:
		shake_strength = lerpf(shake_strength,0,shakeFade * delta)
		offset = randomOffset()
	#else:
		#offset = Vector2(0.0,32.0)
	
func randomOffset() -> Vector2:
	return Vector2(rng.randf_range(-shake_strength,shake_strength),rng.randf_range(-shake_strength,shake_strength)+32.0)


func _on_homunculus_damage_taken() -> void:
	shakeApplied = true
