extends Node2D

var state = 'play'
var ball_scene = preload("res://scenes/ball.tscn")
var tile_scene = preload("res://scenes/tile.tscn")
export var width = 3
export var height = 3
export var offset = 20
export var tile_size = Vector2(80, 80)
export var start_pos = Vector2(200, 100)

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	build_grid()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	if state == 'play':
#		pass
#	pass

func _input(event):
	if event.is_action_pressed("ui_touch"):
#		print(event.as_text())
		var tile = pixel_to_grid(event.position.x, event.position.y)
		if (!is_tile_in_grid(tile)): return
		var new_ball = ball_scene.instance()
		add_child(new_ball)
		var pos = grid_to_pixel(tile.x, tile.y)
		new_ball.position = pos
		
func build_grid():
	print('building le grid')
	for x in width:
		for y in height:
			build_tile_at(grid_to_pixel(x, y))

func build_tile_at(pos):
	var new_tile = tile_scene.instance()
	new_tile.position = pos
	add_child(new_tile)

func pixel_to_grid(x, y):
	x = (x - start_pos.x) / (tile_size.x + offset/2)
	y = (y - start_pos.y) / (tile_size.y + offset/2)
	return Vector2(round(x), round(y))

func grid_to_pixel(x, y):
	return Vector2(start_pos.x + x * (tile_size.x + offset/2), start_pos.y + y * (tile_size.y + offset/2))

func snap_to_grid(pos):
	var tile = pixel_to_grid(pos.x, pos.y)
	var pos_in_grid = grid_to_pixel(tile.x, tile.y)
	return pos_in_grid

func is_tile_in_grid(pos):
	if (pos.x < 0 || pos.y < 0): return false
	if (pos.x >= width || pos.y >= height): return false
	return true
