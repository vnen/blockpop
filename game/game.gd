
extends Node2D

export(AudioStream) var game_bgm

func _ready():
	get_node("/root/sound_manager").bgm(game_bgm)
	get_node("ball").set_pos(get_node("pad/ball_start").get_global_pos())
	get_node("ball").start()
	var left_wall = get_node("walls/left")
	var t = left_wall.get_shape(0)
	var right_wall = get_node("walls/right")
	var left_limit = left_wall.get_pos().x + 20#left_wall.get_shape(0).get_extents().x
	var right_limit = right_wall.get_pos().x - 20#right_wall.get_shape(0).get_extents().x
	get_node("pad").set_limits(left_limit, right_limit)
	get_node("/root/level_manager").advance()
	set_process_input(true)
	get_node("powerup_grabber").connect("body_enter", self, "on_grabber_touch")
	
func _input(event):
	if(!get_tree().is_paused() and event.is_action("pause") and event.is_pressed() and !event.is_echo()):
		get_node("GUI/PauseMenu").popup()
		
	if(OS.is_debug_build() and event.is_action("skip_level") and event.is_pressed() and !event.is_echo()):
		for brick in get_tree().get_nodes_in_group("brick"):
			brick.destroy()
		get_node("ball").call_deferred("on_destroy_brick")

func on_grabber_touch(body):
	body.queue_free()