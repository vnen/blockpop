
extends "res://powerups/base_powerup.gd"

func _init():
	texture = ResourceLoader.load("res://powerups/fast.png")

func apply(pad, ball):
	ball.increase_speed()