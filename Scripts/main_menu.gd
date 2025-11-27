extends Node2D

@onready var menuNewRun = $MenuButtons/New_Run
@onready var menuOptions = $MenuButtons/Options
@onready var menuQuit = $MenuButtons/Quit
@onready var menuNo = $are_you_sure/QuitConfirm/No
@onready var menuYes = $are_you_sure/QuitConfirm/Yes
@onready var quitConfirm = $are_you_sure
func _ready() -> void:
	quitConfirm.visible = false
	menuNewRun.grab_focus()


func _on_new_run_pressed() -> void:
	pass # Replace with function body.


func _on_options_pressed() -> void:
	pass # Replace with function body.


func _on_quit_pressed() -> void:
	quitConfirm.visible = true
	menuNo.grab_focus()


func _on_yes_pressed() -> void:
	get_tree().quit()


func _on_no_pressed() -> void:
	quitConfirm.visible = false
	menuNewRun.grab_focus()
