extends Node2D

var type = 'moo'
var tex_ball = preload("res://assets/ball02.png")
var tex_x = preload("res://assets/x01.png")


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	play_intro()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func setType(new_type):
	type = new_type
	if (type == 'x'):
		$Sprite.set_texture(tex_x)
	if (type == 'ball'):
		$Sprite.set_texture(tex_ball)
		
func matched():
	$TweenSize.interpolate_property(self, "scale", Vector2(1, 1), Vector2(0, 0), 0.3, Tween.TRANS_BACK, Tween.EASE_IN)
	$TweenSize.start()
	$TweenColor.interpolate_property($Sprite, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), 0.3, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$TweenColor.start()

func play_intro():
	$TweenSize.interpolate_property(self, "scale", Vector2(0, 0), Vector2(1, 1), 0.3, Tween.TRANS_BACK, Tween.EASE_OUT)
	$TweenSize.start()
