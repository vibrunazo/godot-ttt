extends Node2D

class_name Piece

var type := 'moo'
var level := 0
var grid = null
var tile := Vector2(0, 0)
var tex


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	play_intro()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func setup(grid_ref, new_tile, new_type, new_level := 0):
	grid = grid_ref
	tile = new_tile
	set_level(new_level)
	set_type(new_type)
	
#static func get_tex_from_type(new_type: String):
#	var tex_ball := grid.tex_ball
#	var tex_x := preload("res://assets/leaf02.png")
#	if (new_type == 'x'):
#		return tex_x
#	if (new_type == 'ball'):
#		return tex_ball

func set_type(new_type):
	type = new_type
	tex = grid.get_tex_from_type(new_type, level)
	$Sprite.set_texture(tex)

func set_level(new_level):
	level = new_level
	if (level > 1):
		$TextLevel.visible = true
		$TextLevel.text = "%d" % level
		
func matched():
	grid.tiles[tile.x][tile.y] = null
	$TweenSize.interpolate_property(self, "scale", Vector2(1, 1), Vector2(0, 0), 0.3, Tween.TRANS_BACK, Tween.EASE_IN)
	$TweenSize.start()
	$TweenColor.interpolate_property($Sprite, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), 0.3, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$TweenColor.start()

func play_intro():
	$TweenSize.interpolate_property(self, "scale", Vector2(0, 0), Vector2(1, 1), 0.3, Tween.TRANS_BACK, Tween.EASE_OUT)
	$TweenSize.start()


func _on_TweenColor_tween_all_completed():
	queue_free()
