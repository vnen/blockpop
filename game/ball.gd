	
extends RigidBody2D

export(float) var initial_speed = 150.0
export(float) var pad_acceleration = 1.02
export(float) var max_speed = 500.0
export(float) var min_speed = 100.0
export(float) var acceleration_factor = 1.2

var speed
var initial_direction = Vector2(1, 1).normalized()
var direction

func _ready():
	direction = initial_direction
	pass

func start():
	speed = 0
	set_linear_velocity(direction * speed)
	set_process_input(true)
	
func _input(event):
	if(speed == 0):
		if(event.is_pressed() and !event.is_echo() and event.is_action("start")):
			direction = initial_direction
			speed = initial_speed
			set_linear_velocity(speed * direction)
	
func _integrate_forces(state):
	state.set_angular_velocity(0)
	
	if(speed == 0):
		reset_pos()
	if(!get_node("/root/level_manager").locked and state.get_contact_count() > 0):
		var body = state.get_contact_collider_object(0)
		if(body.is_in_group("bottom")):
			state.set_linear_velocity(Vector2(0, 0))
			speed = 0
			var lives = get_node("/root/score_manager").decrease_life()
			reset_pos()
		elif(body.is_in_group("brick")):
			body.destroy()
			call_deferred("on_destroy_brick")
		elif(body.is_in_group("pad")):
			var ball_pos = get_global_pos()
			var pad_pos = body.get_global_pos()
			var pad_to_ball = (ball_pos - pad_pos).normalized()
			speed *= pad_acceleration
			set_linear_velocity(pad_to_ball * speed)

func on_destroy_brick():
	if(get_tree().get_nodes_in_group("brick").size() == 0):
		speed = 0
		get_node("/root/level_manager").advance()
		
func reset_pos():
	var start = get_tree().get_nodes_in_group("ball_start")
	if(start.size() == 0):
		return
	call_deferred("set_pos", start[0].get_global_pos())
	
func increase_speed():
	if(speed != 0):
		speed = clamp(speed * acceleration_factor, min_speed, max_speed)
		update_velocity()
		
func decrease_speed():
	if(speed != 0):
		speed = clamp(speed / acceleration_factor, min_speed, max_speed)
		update_velocity()
		
func update_velocity():
	direction = get_linear_velocity().normalized()
	set_linear_velocity(direction * speed)