extends CharacterBody2D
class_name Player


@onready var animatedSprite = $PlayerAnimation


@export var speed = 6000
@export var jumpForce = 200
@export var gravity = 400
var active = true

func _physics_process(delta):
	if !is_on_floor():
		velocity.y += gravity * delta
		if velocity.y > 800:
			velocity.y = 800

	var direction = 0
	if active:
		if Input.is_action_just_pressed("jump") && is_on_floor():
			jump(jumpForce)
		direction = Input.get_axis("left", "right")
	if direction !=0:
		animatedSprite.flip_h = (direction == -1)
		
	velocity.x = direction * speed * delta	
	move_and_slide()
	
	update_animations(direction)
	
func update_animations(direction):
	if is_on_floor():
		if direction == 0:
			animatedSprite.play("Idle")
		else:
			animatedSprite.play("Run")
	else:
		if velocity.y < 0:
			animatedSprite.play("Jump")
		else:
			animatedSprite.play("Fall")

func jump(force):
	velocity.y = -force
