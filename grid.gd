extends Node2D

var state = 'play'
var ball_scene = preload("res://ball.tscn")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	print('ready! grid!')
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if state == 'play':
		pass
	pass

func _input(event):
	if event.is_action_pressed("ui_touch"):
		print(event.as_text())
		var new_ball = ball_scene.instance()
		add_child(new_ball)
		new_ball.position = event.position
		
