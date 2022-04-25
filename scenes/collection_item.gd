extends Control

export var type := 'life'
export var level := 0
export var ammount := 0


func _ready():
	update()
#	pass

func update():
#	var label = find_node("Label")
	var label = $HBoxContainer/MarginContainer/Label
	label.text = "x%d" % ammount
	var tex = $"/root/Global".get_tex_from_type(type, level)
	var image = $HBoxContainer/TextureRect
	image.texture = tex
	if (ammount == 0):
		image.modulate = Color(0, 0, 0)
		label.visible = false
	else:
		image.modulate = Color(1, 1, 1)
		label.visible = true
