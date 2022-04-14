extends CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	var load_data = load_game()
	$Control/grid.start(load_data)
	# to update next
	_on_grid_played_turn($Control/grid)
#	save_game()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func load_game():
	var save_file := File.new()
	if not save_file.file_exists("user://game.save"):
		print('no save file')
		return null
	save_file.open("user://game.save", File.READ)
	var load_data = {}
	load_data.version = save_file.get_line()
	load_data.grid = parse_json(save_file.get_line())
	load_data.score = int(save_file.get_line())
	load_data.next = save_file.get_line()
	save_file.close()
#	print('loaddata:')
#	print(load_data)
	return load_data

func save_game():
	var save_file := File.new()
	save_file.open("user://game.save", File.WRITE)
	
	var json = get_JSON_from_grid()
	save_file.store_line('1')
	save_file.store_line(json)
	save_file.store_line(str($Control/grid.score))
	save_file.store_line($Control/grid.next)
	
	save_file.close()

func reset_game():
	var save_file := File.new()
	save_file.open("user://game.save", File.WRITE)
	save_file.close()
	
func restart_game():
	reset_game()
	get_tree().reload_current_scene()
	
	
func update_score(new_score: int):
	$Control/Score.text = "Score: %d" % new_score

func get_JSON_from_grid():
	var tiles = $Control/grid.tiles
	var result = []
	for row in tiles:
		for piece in row:
			if !piece: 
				result.append([])
				continue
			var p = piece.get_json()
			result.append(p)
	
	var json = to_json(result)
#	print(json)
	return json


func _on_grid_played_turn(grid_ref: Grid):
	var next = grid_ref.next
	var tex = grid_ref.get_tex_from_type(next)
	$next.set_next(tex)
	update_score(grid_ref.score)
	save_game()
	
func game_over():
	$game_over.popup_centered()

func _on_RestartButton_pressed():
	game_over()
#	reset_game()

func _on_grid_game_over(grid_ref):
	game_over()

func _on_game_over_confirmed():
	restart_game()
