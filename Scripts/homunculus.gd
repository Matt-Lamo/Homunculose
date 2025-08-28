extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
@onready var state = "Idle"
@onready var animated_sprite_2d = $AnimatedSprite2D

func _ready() -> void:
	Global.charge = Global.maxCharge

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta


	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("left", "right")
	if direction !=0:   
		animated_sprite_2d.flip_h = (direction ==-1)  #flips animation 
		animated_sprite_2d.play("walking")
	else:
		animated_sprite_2d.play("idle")
		
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()


func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.name == "Hazards":
		print("HAZARD HIT.")
