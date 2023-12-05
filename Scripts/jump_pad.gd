extends Area2D

@onready var animation = $Animation
@export var jump_force = 300

func _on_body_entered(body):
	animation.play("Jump")
	body.jump(jump_force)
