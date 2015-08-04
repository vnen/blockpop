
extends PopupPanel

var save_game_scene = preload("res://save_game.scn")

func _ready():
	get_node("buttons/resume").connect("pressed", self, "on_resume_click")
	get_node("buttons/main_menu").connect("pressed", self, "on_main_menu_click")
	get_node("buttons/quit").connect("pressed", self, "on_quit_click")
	get_node("buttons/settings").connect("pressed", self, "on_settings_click")
	get_node("buttons/save").connect("pressed", self, "on_save_click")
	set_process_input(true)
	get_node("buttons/resume").grab_focus()
	
	connect("about_to_show", self, "on_show")
	connect("hide", self, "on_hide")
	connect("exit_tree", self, "on_hide")
	
func _input(event):
	if(event.is_action("ui_cancel") and event.is_pressed() and !event.is_echo()):
		on_resume_click()

func on_resume_click():
	hide()
	unpause()
	
func on_main_menu_click():
	get_node("/root/score_manager").reset_score()
	get_node("/root/scene_manager").goto_scene("res://menu.scn")
	unpause()
	
func on_quit_click():
	get_tree().quit()
	
func on_show():
	get_tree().set_pause(true)
	
func on_hide():
	#get_tree().set_pause(false)
	pass
	
func on_settings_click():
	var settings = get_tree().get_nodes_in_group("settings")
	if(settings.size() == 0):
		return
	settings = settings[0]
	hide()
	get_tree().set_pause(true)
	settings.show()
	settings.notification(settings.NOTIFICATION_POST_POPUP)
	
func on_save_click():
	var savegame = save_game_scene.instance()
	get_parent().add_child(savegame)
	get_tree().set_pause(true)
	savegame.show_modal(true)
	
func unpause():
	get_tree().set_pause(false)