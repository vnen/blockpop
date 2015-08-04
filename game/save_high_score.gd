
extends PopupDialog

# member variables here, example:
# var a=2
# var b="textvar"

func _ready():
	get_node("score").set_text(str(get_node("/root/score_manager").get_score()))
	get_node("name_field/text").grab_focus()
	get_node("buttons/cancel").connect("pressed", self, "on_cancel_click")
	get_node("buttons/save").connect("pressed", self, "on_save_click")
	set_process_input(true)
	
func _input(event):
	if(event.is_action("ui_accept") and event.is_pressed() and !event.is_echo()):
		on_save_click()
	if(event.is_action("ui_cancel") and event.is_pressed() and !event.is_echo()):
		on_cancel_click()
	
func on_cancel_click():
	get_node("/root/score_manager").reset_score()
	get_node("/root/scene_manager").goto_menu()
	queue_free()
	
func on_save_click():
	var name = get_node("name_field/text").get_text()
	if(name):
		get_node("/root/score_manager").add_high_score(name)
	on_cancel_click()
	


