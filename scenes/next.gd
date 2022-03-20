extends Control

var tex_x := preload("res://assets/leaf02.png")


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func set_next(tex):
	print('setting texture on next: %s' % tex)
	$Tex.texture = tex
