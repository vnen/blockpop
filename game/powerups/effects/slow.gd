
extends "res://powerups/base_powerup.gd"

func _init():
	texture = ResourceLoader.load("res://powerups/slow.png")

func apply(pad, ball):
	ball.decrease_speed()