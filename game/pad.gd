
extends StaticBody2D

export(float) var pad_speed = 150.0
export(Color) var pad_color = Color(1, 1, 1)
export(int) var max_pad_level = 4
export(int) var min_pad_level = 1

var pad_size = Vector2(160, 32)
var pad_level = 2
var left_limit = -900
var right_limit = 8000
var sprite_y

func _ready():
	set_process(true)
	for sprite in get_node("sprites").get_children():
		sprite.set_modulate(pad_color)
	for sprite in get_node("base/middle").get_children():
		sprite.set_modulate(pad_color)
	sprite_y = get_node("sprites/left").get_pos().y
	set_size_from_level()
	set_process_input(true)
	
func _input(event):
	if(OS.is_debug_build() and event.is_pressed() and !event.is_echo()):
		if(event.is_action("increase_level")):
			increase_level()
		elif(event.is_action("decrease_level")):
			decrease_level()
	
func _process(delta):
	var move_left = Input.is_action_pressed("move_left")
	var move_right = Input.is_action_pressed("move_right")
	var pos = get_pos()
	var direction = Vector2(0, 0)
	
	if(move_left):
		direction.x = -1
	elif(move_right):
		direction.x = 1
	
	var motion = direction * pad_speed * delta
	var new_pos = pos + motion
	new_pos.x = clamp(new_pos.x, left_limit + (pad_size.x/2), right_limit - (pad_size.x/2))
	set_pos(new_pos)
	
func set_limits(left, right):
	left_limit = float(left)
	right_limit = float(right)
	
func set_size_from_level():
	var half_w = pad_level * 16
	pad_size.x = (2 + ((pad_level * 2) - 1)) * 32
	get_node("sprites/left").set_pos(Vector2(-half_w, sprite_y))
	get_node("sprites/right").set_pos(Vector2(half_w, sprite_y))
	
	for i in range(get_shape_count()):
		remove_shape(i)
	var new_shape = RectangleShape2D.new()
	new_shape.set_extents(pad_size / 2)
	add_shape(new_shape)
	update_middle_sprites()
	
func update_middle_sprites():
	var base_sprite = get_node("base/middle")
	var middle = get_node("middle")
	for sprite in middle.get_children():
		sprite.queue_free()
	for i in range(-(pad_level - 1), pad_level):
		var sprite = base_sprite.duplicate()
		sprite.set_modulate(pad_color)
		# adjust position
		var new_pos = sprite.get_pos() + Vector2(i * 16, 0)
		sprite.set_pos(new_pos)
		# add child
		middle.add_child(sprite)
	
func increase_level():
	set_level(pad_level + 1)
	
func decrease_level():
	set_level(pad_level - 1)
	
func set_level(l):
	pad_level = int(clamp(l, min_pad_level, max_pad_level))
	set_size_from_level()
