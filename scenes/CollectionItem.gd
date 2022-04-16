extends Control

export var type := 'life'
export var level := 0
export var ammount := 1


func _ready():
	update()

func update():
	$HBoxContainer/Label.text = "x %d" % ammount
	var tex = $"/root/Global".get_tex_from_type(type, level)
	$HBoxContainer/TextureRect.texture = tex
