extends Node2D

var state = 'play'
var turn = 0
var ball_scene = preload("res://scenes/piece.tscn")
var tile_scene = preload("res://scenes/tile.tscn")
export var width = 3
export var height = 3
export var offset = 20
export var tile_size = Vector2(80, 80)
export var start_pos = Vector2(200, 100)

var tiles = []

# Called when the node enters the scene tree for the first time.
func _ready():
	build_grid()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	if state == 'play':
#		pass
#	pass

func _input(event):
	if event.is_action_pressed("ui_touch") && state == 'play':
#		print(event.as_text())
		var tile = pixel_to_grid(event.position.x, event.position.y)
		if (!is_tile_in_grid(tile)): return
		if (tiles[tile.x][tile.y] != null): return
		build_piece_at_tile(tile)
		turn += 1
		print(tiles)
		
func build_grid():
	print('building le grid')
	for x in width:
		tiles.append([])
		for y in height:
			build_tile_at(grid_to_pixel(x, y))
			tiles[x].append(null)

func build_tile_at(pos):
	var new_tile = tile_scene.instance()
	new_tile.position = pos
	add_child(new_tile)

func build_piece_at_tile(tile):
	var pos = grid_to_pixel(tile.x, tile.y)
	var new_ball = ball_scene.instance()
	add_child(new_ball)
	new_ball.position = pos
	if (turn %2 == 0): new_ball.setType('ball')
	else: new_ball.setType('x')
	tiles[tile.x][tile.y] = new_ball
	if (tiles[2][1]): print(tiles[2][1].type)
	check_win()

func check_win():
	for x in width:
		for y in height:
			if check_match_at(x, y): 
				print('WIN for %s' % tiles[x][y].type)
				state = 'pause'
				return true
	return false

func check_match_at(x, y):
	var size = 3
	var combo_count = 0
	var combo_tiles = [tiles[x][y]]
	for i in range(1, size + 10):
		if check_match_pair(x,y, x+i,y):
			combo_count += 1
			combo_tiles.append(tiles[x+i][y])
		else: break
	if combo_count >= size - 1: 
		for tile in combo_tiles:
			tile.matched()
		return true
	return false
	
func check_match_pair(tile_a_x, tile_a_y, tile_b_x, tile_b_y):
	if (tile_a_x >= width || tile_a_y >= height): return false
	if (tile_b_x >= width || tile_b_y >= height): return false
	var tile_a = tiles[tile_a_x][tile_a_y]
	var tile_b = tiles[tile_b_x][tile_b_y]
	if (tile_a == null || tile_b == null): return false
	return tile_a.type == tile_b.type

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

func grid_to_id(pos):
	return pos.x + pos.y * width

func id_to_grid(id):
	return Vector2(0, 0)
