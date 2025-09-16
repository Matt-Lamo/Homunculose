extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const sawDamage = 15
const hazardDamage = 15
const wallGravity = 0
var deathBool = true #flips when player dies to break physics_process loop
enum States {IDLE, WALKING, FALLING, WALL_SLIDING, JUMPING}
var state: States = States.IDLE
@onready var animatedSprite2d = $AnimatedSprite2D


func _ready() -> void:
	Global.charge = Global.maxCharge


func check_charge() -> void:
	if Global.charge <= 0:
		if deathBool: #should trigger first time player runs out of charge
			deathBool = false
			#animatedSprite2d.play("dead") NEED TO DRAW DEATH ANIMATION
			set_physics_process(false)
			
		

func set_state(direction: float) -> void:
	if direction !=0:   
		state = States.WALKING
		print("state WALKING")
	elif direction !=0 and Input.is_action_just_pressed("ui_accept") and is_on_floor():
		state = States.JUMPING
		print("state JUMPING")
	else:
		state = States.IDLE
		print("state IDLE")
	if not is_on_floor():
		state = States.FALLING
		print("state FALLING  ")
	#if is_on_wall_only():
		#state = States.WALL_SLIDING
		#print("state WALL SLIDING")
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		state = States.JUMPING
		print("state JUMPING")

func _physics_process(delta: float) -> void:
	check_charge() #checks player charge for game over

	var direction := Input.get_axis("left", "right")
	set_state(direction)
	velocity += get_gravity() * delta
	if state == States.IDLE:
		velocity.x = direction * SPEED
		animatedSprite2d.play("idle")
	elif state == States.WALKING:
		animatedSprite2d.flip_h = (direction ==-1)  #flips animation WHEN WALKING STATE
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
		animatedSprite2d.play("walking")
	elif state == States.WALL_SLIDING:
		animatedSprite2d.play("wall_sliding")
	elif state == States.JUMPING:
		velocity.y = JUMP_VELOCITY #JUMPING STATE
	elif state == States.FALLING:
		pass#velocity += get_gravity() * delta  #FALLING STATE
	elif state == States.WALL_SLIDING:
		pass
	
	
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
		set_physics_process(false)
		pass #change scene to transition to next level
	elif animatedSprite2d.animation == "jumping":
		animatedSprite2d.play("falling")


func _on_saw_body_entered(body: Node2D) -> void:
	Global.charge -= sawDamage
