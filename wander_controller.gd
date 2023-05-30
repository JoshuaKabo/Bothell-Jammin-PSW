extends Node2D

@export var wander_range: int = 64

var start_pos
var target_pos
var wander_timer


# Called when the node enters the scene tree for the first time.
func _ready():
	wander_timer = get_node("wander_timer")
	start_pos = global_position
	target_pos = global_position

func update_target_pos():
	var target_vector = Vector2(randf_range(-wander_range, wander_range), randf_range(-wander_range, wander_range))
	target_pos = start_pos + target_vector


func get_target_pos():

	return target_pos


func start_wander_timer(duration):
	update_target_pos()
	wander_timer.start(duration)


func get_time_left():
	return wander_timer.time_left


func _on_wander_timer_timeout():
	update_target_pos()
