extends Node

var saves = []
var save_path = "user://save.dat"
var save_pass = "some strong password"
var max_saves = 5

func _ready():
	load_saves_from_disk()
	set_process_input(true)

func _input(event):
	if(event.is_action("save") and event.is_pressed() and !event.is_echo()):
		var s = new_save_game()
		save_game(0)
		save_saves_to_disk()
		print(s.to_json())
	
func load_saves_from_disk():
	var file = File.new()
	if (OK == file.open_encrypted_with_pass(save_path, file.READ, save_pass)):
		saves = []
		max_saves = file.get_32()
		while(!file.eof_reached()):
			var s = file.get_var()
			if(typeof(s) == TYPE_DICTIONARY):
				saves.append(s)
	else:
		saves = []
		for i in range(max_saves):
			saves.append({"saved": false})
			
	file.close()
	
func save_saves_to_disk():
	var file = File.new()
	if (OK == file.open_encrypted_with_pass(save_path, file.WRITE, save_pass)):
		file.store_32(max_saves)
		for i in range(saves.size()):
			file.store_var(saves[i])
		file.close()
		return true
	else:
		return false
	
func get_saves():
	return saves
	
func save_game(index):
	if(index >= 0 and index < max_saves):
		saves[index] = new_save_game()
		
func new_save_game():
	var score = get_node("/root/score_manager")
	var save = {
		"saved": true,
		"level": get_node("/root/level_manager").currentLevel,
		"pad_level": get_tree().get_nodes_in_group("pad")[0].get("pad_level"),
		"score": score.get_score(),
		"lives": score.get_lives(),
		"date": OS.get_date(),
		"time": OS.get_time()
	}
	return save
	
func load_game(index):
	if(index < 0 or index >= saves.size() ):
		return false
	var save = saves[index]
	if(!save["saved"]):
		return false
	get_node("/root/scene_manager").goto_scene("res://game.scn")
	call_deferred("_update_game_from_load", index)

func _update_game_from_load(index):
	var game = get_tree().get_nodes_in_group("game")
	if(game.size() == 0):
		call_deferred("_update_game_from_load", index)
		return
	var save = saves[index]
	var score_manager = get_node("/root/score_manager")
	score_manager.set_score(save["score"])
	score_manager.set_lives(save["lives"])
	get_node("/root/level_manager").currentLevel = save["level"]
	get_tree().get_nodes_in_group("pad")[0].set_level(save["pad_level"])
	
	
func format_date(date, time):
	var d = str(date["year"]) + "-" + str(date["month"]).pad_zeros(2) + "-" + str(date["day"]).pad_zeros(2)
	var t = str(time["hour"]).pad_zeros(2) + ":" + str(time["minute"]).pad_zeros(2) + ":" + str(time["second"]).pad_zeros(2)
	return d + " " + t