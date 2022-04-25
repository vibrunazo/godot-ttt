extends Control


func _ready():
	pass


func _on_ButtonExit_pressed():
	get_tree().quit()


func _on_ButtonPlay_pressed():
	get_tree().change_scene("res://scenes/main.tscn")
