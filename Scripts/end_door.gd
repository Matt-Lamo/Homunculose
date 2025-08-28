extends Area2D

var opened = false
@onready var playerInArea = false
@onready var animatedSprite2d = $AnimatedSprite2D
func _ready() -> void:
	opened = false
	
func check_input() -> void:
	if playerInArea == true:
		if Input.is_action_just_pressed("up"):
			print("PLAYER INPUT DETECTED NEAR DOOR.")
			#SEND SIGNAL TO PLAYER TO FREEZE AND PLAY ANIMATION
			if animatedSprite2d.animation == "Idle":
				animatedSprite2d.play("Open Animation")
		
	

func _process(delta: float) -> void:
	check_input()




func _on_body_entered(body: Node2D) -> void:
	if body.name == "Homunculus":
		playerInArea = true
		print("Player Entered Area.")


func _on_body_exited(body: Node2D) -> void:
	if body.name == "Homunculus":
		playerInArea = false
		print("Player Left Area.")


func _on_animated_sprite_2d_animation_finished() -> void:
	if animatedSprite2d.animation == "Open Animation":
		animatedSprite2d.play("Open")
