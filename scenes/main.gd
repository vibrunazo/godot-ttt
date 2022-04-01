extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var grid_data = load_game()
	$Control/grid.start(grid_data)
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
	print('found save file')
	save_file.open("user://game.save", File.READ)
	print("pos:  %s" % save_file.get_position())
	print("len:  %s" % save_file.get_len())
	print("line: %s" % save_file.get_line())
	var grid_data = save_file.get_line()
	print("grid: %s" % grid_data)
	print("pos:  %s" % save_file.get_position())
	print("len:  %s" % save_file.get_len())
	save_file.close()
	return parse_json(grid_data)

func save_game():
	print("saving game")
	var save_file := File.new()
	save_file.open("user://game.save", File.WRITE)
	
	var json = get_JSON_from_grid()
	save_file.store_line("moo moo")
	save_file.store_line(json)
	
	save_file.close()
	print("saved file")

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
	print(json)
	return json


func _on_grid_played_turn(grid_ref: Grid):
	var next = grid_ref.next
	var tex = grid_ref.get_tex_from_type(next)
	$next.set_next(tex)
	save_game()
	


func _on_RestartButton_pressed():
	print('restart')
	get_tree().reload_current_scene()
	pass # Replace with function body.
