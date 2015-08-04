
extends Node2D


func _ready():
	var colors = [
		"8d8b90",
		"f92d52",
		"f93b2f",
		"f99205",
		"fcc803",
		"4ed55f",
		"5ac4f6",
		"36a6d6",
		"0376f7",
		"5752d0",
		"FFFFFF",
	]
	
	var base_point = 100
	
	for i in range(colors.size()):
		var c = Color(colors[i])
		var p = base_point * (i + 1)
		var n = get_node(str(i))
		for brick in n.get_children():
			brick.set("brick_color", c)
			brick.set("brick_value", p)
			brick.set("min_drop", 19)
			brick.modulate()
	


