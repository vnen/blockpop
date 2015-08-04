
extends PopupPanel

func _ready():
	load_settings()
	get_node("controls/reset").connect("pressed", self, "on_reset_click")
	get_node("controls/back").connect("pressed", self, "on_back_click")
	get_node("controls/bgm_slider").connect("value_changed", self, "on_range_change")
	get_node("controls/sfx_slider").connect("value_changed", self, "on_range_change")
	set_process_input(true)
	
func _input(event):
	if(event.is_action("ui_cancel") and event.is_pressed() and !event.is_echo()):
		on_back_click()
	
func _notification(what):
	if(what == NOTIFICATION_POST_POPUP):
		get_node("controls/back").grab_focus()
	
func load_settings():
	var manager =  get_node("/root/settings_manager")
	get_node("controls/bgm_slider").set_value(manager.get_setting("audio", "bgm"))
	get_node("controls/sfx_slider").set_value(manager.get_setting("audio", "sfx"))

func save_settings():
	var manager =  get_node("/root/settings_manager")
	manager.set_setting("audio", "bgm", int(get_node("controls/bgm_slider").get_value()))
	manager.set_setting("audio", "sfx", int(get_node("controls/sfx_slider").get_value()))

func on_reset_click():
	var manager = get_node("/root/settings_manager")
	manager.reset_settings()
	load_settings()
	get_node("/root/sound_manager").update_settings()
	
func on_back_click():
	save_settings()
	get_node("/root/settings_manager").save_settings()
	get_tree().set_pause(false)
	hide()
	
func on_range_change(val):
	save_settings()
	get_node("/root/sound_manager").update_settings()