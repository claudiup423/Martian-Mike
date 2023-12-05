extends StaticBody2D

@onready var spawn_position = $Marker

func get_spawnd_pos():
	return spawn_position.global_position
