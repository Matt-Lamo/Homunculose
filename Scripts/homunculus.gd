extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const WALL_JUMP_VELOCITY = Vector2(200, -400)
const wall_jump_push_force = 300.0
const sawDamage = 15
const hazardDamage = 15
const wallGravity = 600.0
const defaultGravity = 1100.0
var deathBool = true #flips when player dies to break physics_process loop
enum States {IDLE, WALKING, FALLING, WALL_SLIDING, JUMPING}
var state: States = States.IDLE
var previousState: States = States.IDLE
@onready var animatedSprite2d = $AnimatedSprite2D
@onready var rayCastLeft = $RayCastLeft
@onready var rayCastRight = $RayCastRight
@onready var wallJumpCooldown = $WallJumpCooldown


func _ready() -> void:
	Global.charge = Global.maxCharge
	wallJumpCooldown.start()


func check_charge() -> void:
	if Global.charge <= 0:
		if deathBool: #should trigger first time player runs out of charge
			deathBool = false
			#animatedSprite2d.play("dead") NEED TO DRAW DEATH ANIMATION
			set_physics_process(false)
			
		

func set_state(direction: float) -> void:
	previousState = state
	if is_on_wall_only() and (rayCastLeft.is_colliding() or rayCastRight.is_colliding()):
		state = States.WALL_SLIDING
	elif direction !=0:   
		state = States.WALKING
	else:
		state = States.IDLE

	if Input.is_action_just_pressed("jump") and (is_on_floor() or is_on_wall()):
		state = States.JUMPING

func _physics_process(delta: float) -> void:
	ProjectSettings.set_setting("physics/2d/default_gravity", defaultGravity)
	#print(wallJumpCooldown.time_left)
	check_charge() #checks player charge for game over

	var direction := Input.get_axis("left", "right")
	set_state(direction)
	velocity += get_gravity() * delta
	match state:
		States.IDLE:
			if wallJumpCooldown.is_stopped():
				velocity.x = direction * SPEED
			animatedSprite2d.play("idle")
		States.WALKING:
			if(wallJumpCooldown.is_stopped()):
				if direction:
					velocity.x = direction * SPEED
				else:
					velocity.x = move_toward(velocity.x, 0, SPEED)
			animatedSprite2d.flip_h = (direction ==-1)  #flips animation WHEN WALKING STATE
			animatedSprite2d.play("walking")
		States.WALL_SLIDING:
			ProjectSettings.set_setting("physics/2d/default_gravity", wallGravity)
			if direction != 0:
				velocity.x = direction * SPEED
			animatedSprite2d.play("wall_sliding")
		States.JUMPING:
			if previousState == States.WALL_SLIDING:
				var wall_jump_velocity = WALL_JUMP_VELOCITY
				print("Previous State WALL SLIDING")
				if rayCastLeft.is_colliding():
					print("RAYCAST LEFT")
					if(rayCastLeft.get_collider().is_in_group("Walls")): #checks if colliding with wall
						print("WALL JUMP LEFT")
						
						velocity = wall_jump_velocity
						wallJumpCooldown.start()
				elif rayCastRight.is_colliding(): #checks if colliding with wall
					print("RAYCAST RIGHT")
					if(rayCastRight.get_collider().is_in_group("Walls")): #checks if colliding with wall
						print("WALL JUMP RIGHT")
						wall_jump_velocity.x *= -1
						velocity = wall_jump_velocity
						wallJumpCooldown.start()
			else:
				print("JUMP NORMAL")
				velocity.y = JUMP_VELOCITY #JUMPING STATE


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
