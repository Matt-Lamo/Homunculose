extends Area2D

@export var signText = ""
@onready var textBoxText = $TextBox/MarginContainer/Label
@onready var textBox = $TextBox


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	textBox.visible = false
	textBoxText.text = signText


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	textBoxText = signText


func _on_body_entered(body: Node2D) -> void:
	if body.name == "Homunculus":
		textBox.visible = true 


func _on_body_exited(body: Node2D) -> void:
	if body.name == "Homunculus":
		textBox.visible = false
