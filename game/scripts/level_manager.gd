extends Node

var levels = []
var currentLevel setget _set_current_level,_get_current_level
var locked = 2 setget , _get_locked
func _get_locked():
	return locked
func _set_current_level(value):
	currentLevel = value
	_load_level()
func _get_current_level():
	return currentLevel
	

func _ready():
	currentLevel = -1
	var levels_dir = Directory.new()
	var levels_path = "res://levels"
	levels_dir.open(levels_path)
	levels_dir.list_dir_begin()
	var file = levels_dir.get_next()
	while(file):
		if(file.extension() != "scn"):
			file = levels_dir.get_next()
			continue
		levels.append(levels_path + "/" + file)
		file = levels_dir.get_next()
	levels.sort()
	set_process(true)
	
func advance():
	locked = 2
	var ball = get_tree().get_nodes_in_group("ball")[0]
	ball.set_linear_velocity(Vector2(0,0))
	ball.reset_pos()
	currentLevel += 1
	call_deferred("_load_level")
	
func _load_level():
	var level_node = get_tree().get_nodes_in_group("level")[0]
	for child in level_node.get_children():
		child.free()
		
	if(currentLevel >= levels.size()):
		get_node("/root/score_manager").win()
	else:
		var new_level = ResourceLoader.load(levels[currentLevel], "PackedScene").instance()
		level_node.add_child(new_level)

func _process(delta):
	if(locked > 0):
		locked -= 1
		
func reset():
	currentLevel = -1