extends Node

var tex_dic := {
	'life': [preload("res://assets/seed03.png"), preload("res://assets/leaf02.png"), preload("res://assets/tree.png")],
	'rock': [preload("res://assets/rock01.png"), preload("res://assets/steel02.png")],
	'fire': [preload("res://assets/fire.png"), preload("res://assets/coal.png")]
}

func _ready():
	pass

func get_tex_from_type(new_type: String, level: int = 0):
	if (level >= tex_dic[new_type].size()):
		level = tex_dic[new_type].size() - 1
	return tex_dic[new_type][level]
