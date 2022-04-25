tool
extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	if !Engine.editor_hint:
		queue_free()
		return
	var grid: Grid = get_owner()
	var size := Vector2(
		(grid.width )*grid.tile_size.x + grid.offset*(grid.width -1)*0.5, 
		(grid.height)*grid.tile_size.y + grid.offset*(grid.height-1)*0.5
	)
	
	var center := Vector2(
		grid.position.x + grid.start_pos.x + (size.x - grid.tile_size.x)/2,
		grid.position.y + grid.start_pos.y + (size.y - grid.tile_size.y)/2
	)
	print("size: %s" % size)
	print("center: %s" % center)
	position = center
	var sprite_size := Vector2(400, 400)
	scale = Vector2(size.x/sprite_size.x, size.y/sprite_size.y)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	if Engine.editor_hint:
##		rotation_degrees += 180 * delta
#		var grid: Grid = get_owner()
#		var center = Vector2(grid.position.x, grid.position.y)
#		scale = Vector2(grid.width, grid.height)
##	else:
#		rotation_degrees -= 180 * delta
