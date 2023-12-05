extends Control

@onready var time = $Time

func set_time_label(new_time):
	time.text = "TIME: " +str(new_time)
	
