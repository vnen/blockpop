
extends ScrollContainer

export(int) var scroll_amount = 60

var label_font = preload("res://fonts/tm.fnt")

func _ready():
	var scores = get_node("/root/score_manager").get_high_scores()
	var scores_node = get_node("scores")
	for player in scores:
		var label = Label.new()
		label.set_text(player.name + ": " + str(player.score))
		label.set_align(label.ALIGN_CENTER)
		label.set_v_size_flags(label.SIZE_FILL)
		label.set_h_size_flags(label.SIZE_EXPAND)
		label.add_font_override("font", label_font)
		scores_node.add_child(label)
	scores_node.queue_sort()
	
	set_process_input(true)
	
func close():
	get_node("/root/scene_manager").goto_menu()
	
func _input(event):
	if(event.is_pressed() and !event.is_echo()):
		if(event.is_action("pause")):
			close()
		if(event.is_action("ui_down")):
			set_v_scroll(get_v_scroll() + scroll_amount)
		if(event.is_action("ui_up")):
			set_v_scroll(get_v_scroll() - scroll_amount)