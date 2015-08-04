
extends "res://powerups/base_powerup.gd"

func _init():
	texture = ResourceLoader.load("res://powerups/plus.png")

func apply(pad, ball):
	pad.increase_level()