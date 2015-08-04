
extends "res://powerups/base_powerup.gd"

func _init():
	texture = ResourceLoader.load("res://powerups/minus.png")

func apply(pad, ball):
	pad.decrease_level()