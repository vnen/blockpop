
extends Control

export(AudioStream) var menu_bgm
var load_popup = preload("res://load_game.scn")

signal load_game_closed

func _ready():
	get_node("Buttons/start").connect("pressed", self, "on_start_click")
	get_node("Buttons/quit").connect("pressed", self, "on_quit_click")
	get_node("Buttons/high_scores").connect("pressed", self, "on_high_scores_click")
	get_node("Buttons/settings").connect("pressed", self, "on_settings_click")
	get_node("Buttons/load").connect("pressed", self, "on_load_click")
	get_node("settings").connect("hide", self, "on_settings_hide")
	get_node("Buttons/start").grab_focus()
	get_node("/root/sound_manager").bgm(menu_bgm)
	connect("load_game_closed", self, "on_load_game_closed")

func on_start_click():
	get_node("/root/scene_manager").goto_scene("res://game.scn")
	
func on_quit_click():
	get_tree().quit()
	
func on_high_scores_click():
	get_node("/root/scene_manager").goto_scene("res://high_scores.scn")
	
func on_settings_click():
	var settings = get_node("settings")
	settings.show()
	settings.notification(settings.NOTIFICATION_POST_POPUP)
	get_tree().set_pause(true)
	
func on_settings_hide():
	get_node("Buttons/start").grab_focus()
	
func on_load_click():
	get_tree().set_pause(true)
	var popup = load_popup.instance()
	add_child(popup)
	popup.popup()
	
func on_load_game_closed():
	get_node("Buttons/start").grab_focus()