
extends WindowDialog

var empty_text = "-- Empty --"

func _ready():
	connect("exit_tree", self, "on_exit_tree")
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
			
	get_node("load").connect("released", self, "on_load_click")
	set_process_input(true)
	
func _input(event):
	get_tree().set_input_as_handled()
	if(event.is_action("pause") or event.is_action("ui_cancel")):
		hide()
	if(event.is_action("ui_accept") and !event.is_pressed() and !event.is_echo()):
		on_load_click()
		
	
func _notification(what):
	if(NOTIFICATION_VISIBILITY_CHANGED == what):
		if(is_visible()):
			var slots = get_node("slots")
			slots.select(0)
			slots.grab_focus()
			get_tree().set_pause(true)
		else:
			hide()
			queue_free()
			get_tree().set_pause(false)
	
func slots_layout():
	var slots = get_node("slots")
	
	slots.set_anchor_and_margin(MARGIN_LEFT, slots.ANCHOR_BEGIN, 30)
	slots.set_anchor_and_margin(MARGIN_TOP, slots.ANCHOR_BEGIN, 50)
	slots.set_anchor_and_margin(MARGIN_RIGHT, slots.ANCHOR_END, 30)
	slots.set_anchor_and_margin(MARGIN_BOTTOM, slots.ANCHOR_END, 50)
	
	slots.set_max_columns(1)
	
func on_load_click():
	var slots = get_node("slots")
	var manager = get_node("/root/savegame_manager")
	for i in range(slots.get_item_count()):
		if(slots.is_selected(i)):
			if(slots.get_item_text(i) == empty_text):
				get_node("alert").popup()
			else:
				manager.load_game(i)
			break
				
func on_confirm(i):
	hide()
	
func on_exit_tree():
	var p = get_parent()
	if(p):
		p.emit_signal("load_game_closed")