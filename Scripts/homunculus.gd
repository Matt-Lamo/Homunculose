extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const sawDamage = 15
const hazardDamage = 15
var deathBool = true #flips when player dies to break physics_process loop
@onready var state = "Idle"
@onready var animatedSprite2d = $AnimatedSprite2D

func _ready() -> void:
	Global.charge = Global.maxCharge

func _physics_process(delta: float) -> void:
	if Global.charge <= 0:
		if deathBool: #should trigger first time player runs out of charge
			deathBool = false
			#animatedSprite2d.play("dead") NEED TO DRAW DEATH ANIMATION
	
		
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		#if velocity.y > 0.0:
		#	animatedSprite2d.play("falling")
		#elif velocity.y < 0.0:
		#	animatedSprite2d.play("jumping")
	#else:
		#animatedSprite2d.play("idle")
		


	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("left", "right")
	if direction !=0:   
		animatedSprite2d.flip_h = (direction ==-1)  #flips animation 
		animatedSprite2d.play("walking")
	else:
		animatedSprite2d.play("idle")
		
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()


func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.name == "Hazards":
		print("HAZARD HIT.")
		Global.charge -= hazardDamage


func _on_end_door_door_animation() -> void:
	print("Signal received.")
	animatedSprite2d.stop()
	animatedSprite2d.play("turning_to_door")



func _on_animated_sprite_2d_animation_finished() -> void:
	if animatedSprite2d.animation == "turning_to_door":
		pass #change scene to transition to next level
	elif animatedSprite2d.animation == "jumping":
		animatedSprite2d.play("falling")


func _on_saw_body_entered(body: Node2D) -> void:
	Global.charge -= sawDamage
