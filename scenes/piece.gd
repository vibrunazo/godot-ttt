extends Node2D

var type = 'moo'
var tex_ball = preload("res://assets/ball02.png")
var tex_x = preload("res://assets/x01.png")


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func setType(new_type):
	type = new_type
	if (type == 'x'):
		$Sprite.set_texture(tex_x)
	if (type == 'ball'):
		$Sprite.set_texture(tex_ball)
