
extends WindowDialog

var empty_text = "-- Empty --"

func _ready():
	var slots = get_node("slots")
	slots_layout()
	var manager = get_node("/root/savegame_manager")
	var saves = manager.saves
	for s in saves:
		if(!s["saved"]):
			slots.add_item(empty_text)
		else:
			var text = manager.format_date(s["date"], s["time"])
			slots.add_item(text)
			
	get_node("save").connect("released", self, "on_save_click")
	set_process_input(true)
	
func _input(event):
	get_tree().set_input_as_handled()
	if(event.is_action("pause") or event.is_action("ui_cancel")):
		hide()
	if(!get_node("confirm").is_visible() and event.is_action("ui_accept") and !event.is_pressed() and !event.is_echo()):
		on_save_click()
	
func _notification(what):
	if(NOTIFICATION_VISIBILITY_CHANGED == what):
		if(is_visible()):
			var slots = get_node("slots")
			slots.select(0)
			slots.grab_focus()
		else:
			hide()
			queue_free()
			var game = get_tree().get_nodes_in_group("game")[0]
			game.set_process_input(true)
	
func slots_layout():
	var slots = get_node("slots")
	
	slots.set_anchor_and_margin(MARGIN_LEFT, slots.ANCHOR_BEGIN, 30)
	slots.set_anchor_and_margin(MARGIN_TOP, slots.ANCHOR_BEGIN, 50)
	slots.set_anchor_and_margin(MARGIN_RIGHT, slots.ANCHOR_END, 30)
	slots.set_anchor_and_margin(MARGIN_BOTTOM, slots.ANCHOR_END, 50)
	
	slots.set_max_columns(1)
	
func on_save_click():
	var slots = get_node("slots")
	var manager = get_node("/root/savegame_manager")
	for i in range(slots.get_item_count()):
		if(slots.is_selected(i)):
			if(slots.get_item_text(i) == empty_text):
				manager.save_game(i)
				manager.save_saves_to_disk()
				hide()
			else:
				var confirm = get_node("confirm")
				confirm.get_ok().connect("pressed", self, "on_confirm", [i])
				confirm.get_cancel().connect("pressed", self, "hide")
				confirm.popup()
			break
				
func on_confirm(i):
	var manager = get_node("/root/savegame_manager")
	manager.save_game(i)
	manager.save_saves_to_disk()
	hide()