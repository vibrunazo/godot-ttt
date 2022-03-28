extends Node2D

class_name Piece

var type := 'moo'
var level := 0
var grid = null
var tile := Vector2(0, 0)
var tex
var can_match := true


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
	set_text()
	check_family()
	connect_signals()

func check_family():
	if (type == 'fire' && level == 0):
		can_match = false
	
func connect_signals():
	var g = grid
	g.connect("played_turn", self, "_on_turn_over")
	
func set_type(new_type):
	type = new_type
	tex = grid.get_tex_from_type(new_type, level)
	$Sprite.set_texture(tex)

func set_level(new_level):
	level = new_level

func set_text():
	var textures = grid.tex_dic[type]
	if (level >= textures.size()):
		$TextLevel.visible = true
		$TextLevel.text = "%d" % level
		
func matched():
	if (!can_match): return
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

func _on_turn_over(grid_ref):
	if type == 'fire' && level == 0:
		move_to_random_neighbor()

func move_to_random_neighbor():
	print("I'm on fire at %s" % tile)
	var neighbors: Array = grid.find_free_neighbors(tile)
	if (neighbors.size() == 0): return
	var rng = randi() % neighbors.size()
	var to := Vector2(neighbors[rng][0], neighbors[rng][1])
	var move_ok = grid.move_piece(tile, to)
	if (!move_ok): return
	tile = to
	var to_pos = grid.grid_to_pixel(to.x, to.y)
	
	$TweenPos.interpolate_property(self, "position", position, to_pos, 0.3, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$TweenPos.start()
	
