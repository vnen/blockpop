
extends Node

var current_playing = null

func _ready():
	update_settings()
	get_node("bgm_player").set_loop(true)

func play(sfx):
	get_node("sfx_player").play(sfx)
	
func bgm(resource):
	if(resource != current_playing and resource extends AudioStream):
		var player = get_node("bgm_player")
		player.set_stream(resource)
		player.play(0)
		current_playing = resource
		
func update_settings():
	var settings = get_node("/root/settings_manager")
	var sfx_player = get_node("sfx_player")
	var bgm_volume = settings.get_setting("audio", "bgm")
	var sfx_volume = settings.get_setting("audio", "sfx")
	get_node("bgm_player").set_volume(float(bgm_volume) / 100.0)
	sfx_player.set_default_volume(float(sfx_volume) / 100.0)
	