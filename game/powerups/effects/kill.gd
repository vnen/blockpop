
extends "res://powerups/base_powerup.gd"

func _init():
	texture = ResourceLoader.load("res://powerups/kill.png")

func apply(pad, ball):
	get_node("/root/score_manager").decrease_life()