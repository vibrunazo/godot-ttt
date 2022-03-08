extends Node2D

var state = 'play'
var ball_scene = preload("res://scenes/ball.tscn")
var tile_scene = preload("res://scenes/tile.tscn")
export var width = 3
export var height = 3
export var offset = 20

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	print('ready! grid!')
	build_grid()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	if state == 'play':
#		pass
#	pass

func _input(event):
	if event.is_action_pressed("ui_touch"):
		print(event.as_text())
		var new_ball = ball_scene.instance()
		add_child(new_ball)
		new_ball.position = event.position
		
func build_grid():
	print('building le grid')
	for x in width:
		for y in width:
			build_tile_at(200 + x * (80 + offset/2), 100 + y * (80 + offset/2))

func build_tile_at(x, y):
	var new_tile = tile_scene.instance()
	new_tile.position = Vector2(x, y)
	add_child(new_tile)
