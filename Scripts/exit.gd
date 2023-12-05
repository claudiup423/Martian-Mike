extends Area2D

@onready var animation = $Animation

func animate():
	animation.play("end")

