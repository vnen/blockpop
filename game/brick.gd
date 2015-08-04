
extends StaticBody2D

export(Color) var brick_color = Color(1, 1, 1)
export(int) var brick_value = 100
# The higher this value the less likely to drop a powerup
export(int, 0, 19) var min_drop = 0

var powerup = preload("res://powerups/powerup.scn")
var powerups = [
	{ "res": preload("res://powerups/effects/kill.gd"), "weight": 1 },
	{ "res": preload("res://powerups/effects/life.gd"), "weight": 1 },
	{ "res": preload("res://powerups/effects/fast.gd"), "weight": 4 },
	{ "res": preload("res://powerups/effects/slow.gd"), "weight": 4 },
	{ "res": preload("res://powerups/effects/plus.gd"), "weight": 6 },
	{ "res": preload("res://powerups/effects/minus.gd"), "weight": 6 }
]
var total_weight = 0

func _ready():
	modulate()
	powerups.sort_custom(self, "powerup_sorter")
	for pp in powerups:
		total_weight += pp.weight
		pp["range"] = total_weight
	
func destroy():
	randomize()
	var chance = randi() % 20
	if(chance >= min_drop):
		drop_powerup()
	queue_free()
	get_node("/root/score_manager").add_score(brick_value)
	get_node("/root/sound_manager").play("brick")

func drop_powerup():
	var p = powerup.instance()
	var fx = pick_random_powerup()
	p.attach_effect(fx)
	var ball = get_tree().get_nodes_in_group("ball")[0]
	get_tree().get_current_scene().add_child(p)
	p.set_global_pos(get_global_pos())
	p.set_linear_velocity(get_global_pos() - ball.get_global_pos())
	
func pick_random_powerup():
	var chance = (randi() % total_weight)
	for pp in powerups:
		if(chance < pp["range"]):
			var instance = pp.res.new()
			instance.set("point_value", (10 - pp.weight) * 100)
			return instance
			
func powerup_sorter(p1, p2):
	if(p1["weight"] < p2["weight"]):
		return true
	else:
		return false
		
func modulate():
	for sprite in get_node("sprites").get_children():
		sprite.set_modulate(brick_color)