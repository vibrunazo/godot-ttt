extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	_on_grid_played_turn($Control/grid)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_grid_played_turn(grid_ref: Grid):
	var next = grid_ref.next
	var tex = grid_ref.get_tex_from_type(next)
	$next.set_next(tex)
	
