extends Node2D

class_name Grid

signal played_turn(grid_ref)
signal game_over(grid_ref)

var state := 'play'
var turn := 0
var next := 'rock'
var piece_scene := preload("res://scenes/piece.tscn")
var tile_scene := preload("res://scenes/tile.tscn")
var tex_dic: Dictionary = {}
export var width := 3
export var height := 3	
export var offset := 20
export var tile_size := Vector2(80, 80)
export var start_pos := Vector2(200, 100)
var tiles = []
var score := 0
var count := {
	"life": {0: 0, 1: 0},
	"rock": {0: 0, 1: 0},
	"fire": {0: 0, 1: 0}
}

# Called when the node enters the scene tree for the first time.
func _ready():
	tex_dic = $"/root/Global".tex_dic

# called from main.gd with load data
func start(data = null):
	if data == null || data.grid == null:
		build_grid()
		update_next()
	else:
		build_grid()
		build_grid_from(data.grid)
		score = data.score
		next = data.next

func pause_game():
	state = 'pause'

func unpause_game():
	state = 'play'

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	if state == 'play':
#		pass
#	pass

func _input(event):
	if event.is_action_pressed("ui_touch") && state == 'play':
#		print(event.as_text())
		var tile = pixel_to_grid(event.position.x - global_position.x, event.position.y - global_position.y)
		if (!is_tile_in_grid(tile)): return
		if (tiles[tile.x][tile.y] != null): return
		play_piece_at_tile(tile)
		emit_signal("played_turn", self)

func build_grid_from(data):
	var i = 0
	for x in width:
#		tiles.append([])
		for y in height:
#			build_tile_at(grid_to_pixel(x, y))
			var piece = data[i]
#			tiles[x].append(null)
			if data[i] == []:
				pass
			else:
				build_piece_at_tile(Vector2(x, y), data[i][0], data[i][1], false)
			i += 1

func build_grid():
	for x in width:
		tiles.append([])
		for y in height:
			build_tile_at(grid_to_pixel(x, y))
			tiles[x].append(null)

func build_tile_at(pos):
	var new_tile = tile_scene.instance()
	new_tile.position = pos
	add_child(new_tile)
#	print('added tile at %s' % pos)

func build_piece_at_tile(tile: Vector2, type: String, level: int = 0, check = true):
	var pos = grid_to_pixel(tile.x, tile.y)
	var new_piece: Piece = piece_scene.instance()
	add_child(new_piece)
	new_piece.position = pos
	new_piece.setup(self, tile, type, level)
	tiles[tile.x][tile.y] = new_piece
	add_count(type, level)
	print(count)
	if check:
		check_match_at(tile.x, tile.y)
		score += 1 + level * 5

func play_piece_at_tile(tile: Vector2):
	build_piece_at_tile(tile, next)
	turn += 1
	if num_free_tiles() == 0:
		game_over()
		return
	update_next()

func add_count(type: String, level: int, add: int = 1):
	if !(type in count):
		count[type] = {0: 0, 1: 0}
	if !(level in count[type]):
		count[type][level] = 0
	count[type][level] = count[type][level] + add
		
func game_over():
	emit_signal("game_over", self)

func update_next():
	var keys = tex_dic.keys()
	var size = keys.size()
#	var next_index := turn % size
	var rng := randi() % 100
	var next_index := 2
	if (rng < 92): next_index = 1
	if (rng < 60): next_index = 0
	next = keys[next_index]
#	if (turn %2 == 0): next = 'life'
#	else: next = 'rock'

func move_piece(from: Vector2, to: Vector2):
	var to_tile: Piece = tiles[to.x][to.y]
	if (to_tile != null): return false
	var from_tile: Piece = tiles[from.x][from.y]
	tiles[to.x][to.y] = from_tile
	tiles[from.x][from.y] = null
	return true

func find_free_neighbors(from):
	var x: int = from.x
	var y: int = from.y
	var directions := [[1, 0], [0, 1], [-1, 0], [0, -1]]
	var found_tiles: Array  = []
	for dir in directions:
		var x2: int = x + dir[0]
		var y2: int = y + dir[1]
		if (is_inside_grid(x2, y2) && tiles[x2][y2] == null):
			found_tiles.append([x2, y2])
	return found_tiles

func num_free_tiles():
	var total := 0
	for x in width:
		for y in height:
			if tiles[x][y] == null: total += 1
	return total
	

func check_win():
	for x in width:
		for y in height:
			if check_match_at(x, y): 
#				print('WIN for %s' % tiles[x][y].type)
				state = 'pause'
				$TimerPause.start(0.5)
				return true
	return false

func check_match_at(x, y):
	var first: Piece = tiles[x][y]
	if (!first.can_match): return
	var size = 3
#	var directions = [[1, 0], [0, 1], [1, 1], [1, -1]]
	var directions := [[1, 0], [0, 1], [-1, 0], [0, -1]]
	var combo_count = 1
	var combo_tiles = [first]
	for dir in directions:
		for i in range(1, size + 10):
			var x2 = x+i*dir[0]
			var y2 = y+i*dir[1]
			if check_match_pair(x,y, x2,y2):
				combo_count += 1
				combo_tiles.append(tiles[x2][y2])
				if i == 1:
					# if the first neighbor is a match, then checks for L matches
					for dir2 in directions:
						# search in all directions except the current direction (that's a straight line)
						# and except going backwards
						# (x y )
						# (x2y2) (x3y3) <- L match
						if dir == dir2: continue
						if dir[0] == -dir2[0] && dir[1] == -dir2[1]: continue
						var x3 = x2 + dir2[0]
						var y3 = y2 + dir2[1]
						if check_match_pair(x2, y2, x3, y3):
							combo_count += 1
							combo_tiles.append(tiles[x3][y3])
						pass
			else: break
	if combo_count >= size: 
#		print('combo', tiles[x][y].type, combo_count)
		for tile in combo_tiles:
			tile.matched()
		build_piece_at_tile(Vector2(x, y), first.type, first.level + 1)
		return true
	return false
	
func check_match_pair(tile_a_x, tile_a_y, tile_b_x, tile_b_y):
	if (tile_a_x >= width || tile_a_y >= height): return false
	if (tile_b_x >= width || tile_b_y >= height): return false
	var tile_a: Piece = tiles[tile_a_x][tile_a_y]
	var tile_b: Piece = tiles[tile_b_x][tile_b_y]
	if (tile_a == null || tile_b == null): return false
	return tile_a.type == tile_b.type && tile_a.level == tile_b.level

func check_match_at_dir(tile_x, tile_y, dir):
	return check_match_pair(tile_x, tile_y, tile_x + dir[0], tile_y + dir[1])

func is_inside_grid(x, y):
	if (x >= width || y >= height): return false
	if (x < 0 || y < 0): return false
	return true

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
	
func get_tex_from_type(new_type: String, level: int = 0):
	return $"/root/Global".get_tex_from_type(new_type, level)

func _on_TimerPause_timeout():
	state = 'play'
