
extends "res://powerups/base_powerup.gd"

func _init():
	texture = ResourceLoader.load("res://powerups/life.png")

func apply(pad, ball):
	var score_manager = get_node("/root/score_manager")
	score_manager.set_lives(score_manager.get_lives() + 1)