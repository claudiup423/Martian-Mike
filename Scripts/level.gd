extends Node2D

@onready var start = $Start
@onready var exit = $Exit
@onready var initial_player_velocity = $Player.velocity
@onready var deadzone = $Deadzone
@onready var hud = $UILayer/HUD
@onready var ui_layer = $UILayer

@export var is_final_level: bool = false
@export var nextLevel: PackedScene = null
@export var level_time = 10

var player = null
var timer_node = null
var time_left

var win = false

func _ready():
	player = get_tree().get_first_node_in_group("player")
	if player != null:
		var traps = get_tree().get_nodes_in_group("traps")
		for trap in traps:
			trap.touched_player.connect(_on_trap_touched_player)
	
	exit.body_entered.connect(_on_exit_body_entered)
	deadzone.body_entered.connect(_on_deadzone_body_entered)
	
	time_left = level_time
	hud.set_time_label(time_left)
	timer_node = Timer.new()
	timer_node.name = "LevelTimer"
	timer_node.wait_time = 1
	timer_node.timeout.connect(_on_level_timer_timeouts)
	add_child(timer_node)
	timer_node.start()

func _on_level_timer_timeouts():
	if !win:
		time_left -= 1
		hud.set_time_label(time_left)
		if time_left < 0:
			reset_player()
			time_left = level_time
			hud.set_time_label(time_left)
	
func _process(delta):
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	elif Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()


func _on_deadzone_body_entered(body):
	reset_player()


func _on_trap_touched_player():
	reset_player()
	
func reset_player():
	player.global_position = start.get_spawnd_pos()
	player.velocity = Vector2.ZERO

func _on_exit_body_entered(body):
	if body is Player:
		if is_final_level || nextLevel != null:
			exit.animate()
			player.active = false
			win = true
			await get_tree().create_timer(1.5).timeout
			if is_final_level:
				ui_layer.show_win_screen(true)
			else:
				get_tree().change_scene_to_packed(nextLevel)
			
		
