
extends Node

var score
var lives 
var initial_lives = 3
var ended = false
var high_scores = []
var high_score_key = "ASD*as9dya9shdasdua9hdu8ahd a9hdb98DGAD(*AGSDA*( GD* "
var max_high_scores = 20

func _ready():
	score = 0
	lives = initial_lives
	set_pause_mode(PAUSE_MODE_PROCESS)
	set_process_input(true)
	
	load_high_scores()
	
	# set base high scores
	var base_scores = []
	base_scores.append({"name": "George", "score": 50})
	base_scores.append({"name": "vnen", "score": 20})
	base_scores.append({"name": "aaa", "score": 10})
	base_scores.append({"name": "bbb", "score": 5})
	base_scores.append({"name": "ccc", "score": 5})
	
	# add base highscores if not full
	var base_idx = 0
	while(high_scores.size() < max_high_scores and base_idx < base_scores.size()):
		high_scores.append(base_scores[base_idx])
		base_idx += 1
	
	high_scores.sort_custom(self, "sort_high_scores")

	
func get_score():
	return score
func set_score(s):
	score = s
func add_score(s):
	score += s
func reset_score():
	set_score(0)
	set_lives(initial_lives)
	get_node("/root/level_manager").reset()
	ended = false

func get_high_scores():
	return high_scores
func sort_high_scores(a1, a2):
	if(a1.score > a2.score):
		return true
	else:
		return false
func save_high_scores():
	var file = File.new()
	file.open_encrypted_with_pass("user://high_scores.dat", file.WRITE, high_score_key)
	file.store_var(high_scores)
	file.close()
func load_high_scores():
	var file = File.new()
	file.open_encrypted_with_pass("user://high_scores.dat", file.READ, high_score_key)
	if(file.is_open()):
		high_scores = file.get_var()
		file.close()
func add_high_score(name):
	if(score >= high_scores[high_scores.size() - 1].score):
		if(high_scores.size() >= max_high_scores):
			high_scores.remove(high_scores.size() - 1)
		high_scores.append({"name": name, "score": score})
		high_scores.sort_custom(self, "sort_high_scores")
		save_high_scores()

func win():
	set_win_lose("You won!")
func lose():
	set_win_lose("You lost!")
	
func set_win_lose(msg):
	var label = get_tree().get_nodes_in_group("win_lose")
	if(label.size() == 0):
		return
	label[0].set_text(msg)
	label[0].show()
	ended = true
	get_tree().set_pause(true)
	save_high_scores()

func get_lives():
	return lives
func set_lives(l):
	lives = l
func decrease_life():
	lives = int(max(0, lives - 1))
	if(lives == 0):
		get_node("/root/sound_manager").play("lose")
		lose()
	else:
		get_node("/root/sound_manager").play("life")
	return lives
	
func _input(event):
	if(ended and (event.is_action("start") or event.is_action("pause")) and event.is_pressed() and !event.is_echo()):
		if(high_scores.size() < max_high_scores or score >= high_scores[high_scores.size() - 1].score):
			var layer = CanvasLayer.new()
			var save_high_score = ResourceLoader.load("res://save_high_score.scn").instance()
			save_high_score.show()
			layer.set_layer(1000)
			layer.add_child(save_high_score)
			get_tree().get_root().add_child(layer)
			
		else:
			reset_score()
			get_node("/root/scene_manager").goto_menu()
			get_tree().set_pause(false)