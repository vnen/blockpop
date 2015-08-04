extends Node

var current_scene = null

func _ready():
	current_scene = get_tree().get_root().get_child(get_tree().get_root().get_child_count() - 1)

func goto_scene(path):
	call_deferred("_goto_scene_deferred", path)
	
func _goto_scene_deferred(path):
	if(current_scene):
		current_scene.free()
	var s = ResourceLoader.load(path, "PackedScene")
	current_scene = s.instance()
	get_tree().get_root().add_child(current_scene)
	get_tree().set_current_scene(current_scene)
	get_tree().set_pause(false)
	
func goto_menu():
	goto_scene("res://menu.scn")