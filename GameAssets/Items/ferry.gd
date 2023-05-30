extends CharacterBody2D

const SPEED = 300.0

var audio_player
@export var sound_ferry_start: AudioStream
@export var sound_ferry_loop: AudioStream
@export var sound_ferry_stop: AudioStream


@export var trans_cam: Camera2D

@export var travel_time = 12.0

var travel_timer: Timer

var initial_pos: Vector2

@export var objective: Node2D
var objective_pos_tolerance = 10.0

var is_traveling = false
var player_car = null

func _ready():
	audio_player = get_node("FerryAudio")
	travel_timer = get_node("TravelTimer")

func _physics_process(_delta):
	# if is_traveling and is not within objective_pos_tolerance of objective
	# move towards objective
	if is_traveling:
		if objective:
			var objective_pos = objective.get_global_position()

			var position_step = lerp(objective_pos, initial_pos, travel_timer.time_left / travel_time)

			global_position = position_step
			player_car.set_global_position(global_position)


	# move_and_slide()

func objective_reached():
	is_traveling = false
	velocity = Vector2(0, 0)
	audio_player.stop()
	audio_player.stream = sound_ferry_stop
	audio_player.play()
	player_car = null
	objective = null

func retrieve_player():
	if player_car:
		# set the player car's position to this ferry's position
		player_car.set_global_position(get_global_position())
			
			
# on collision enter
# if the collision is with the player
# and this ferry has an objective
# go to the objective
func _on_area_2d_body_entered(body:Node2D):
	# we know that the body is a player because of the collision mask
	if objective:
		get_tree().get_root().get_child(0).find_child("l_manager").present_to_player()
		initial_pos = get_global_position()
		player_car = body
		retrieve_player()
		travel_timer.start(travel_time)
		is_traveling = true
		audio_player.stream = sound_ferry_start
		audio_player.play()
		trans_cam.handle_transition()



func _on_travel_timer_timeout():
	objective_reached()
