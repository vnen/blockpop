
extends RigidBody2D

var effect = null

func _ready():
	pass
	
func _integrate_forces(state):
	if(state.get_contact_count() > 0):
		var body = state.get_contact_collider_object(0)
		if(body.is_in_group("pad")):
			if(effect):
				effect.apply(body, get_tree().get_nodes_in_group("ball")[0])
				get_node("/root/sound_manager").play("yeah")
				get_node("/root/score_manager").add_score(int(effect.get("point_value")))
			queue_free()

func attach_effect(fx):
	get_node("sprite").set_texture(fx.get("texture"))
	effect = fx
	add_child(fx)