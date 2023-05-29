extends CharacterBody2D

const SPEED = 300.0

var audio_player
@export var sound_ferry_start: AudioStream
@export var sound_ferry_loop: AudioStream
@export var sound_ferry_stop: AudioStream

@export var objective: Node2D
var objective_pos_tolerance = 10.0

var is_traveling = false
var player_car = null

func _ready():
	audio_player = get_node("FerryAudio")

func _physics_process(_delta):
	# if is_traveling and is not within objective_pos_tolerance of objective
	# move towards objective
	if is_traveling:
		if objective:
			var objective_pos = objective.get_global_position()
			var distance = objective_pos.distance_to(get_global_position())
			if distance > objective_pos_tolerance:
				player_car.set_global_position(get_global_position())
				var direction = (objective_pos - get_global_position()).normalized()
				velocity = direction * SPEED
				move_and_slide()
			else:
				objective_reached()
		else:
			is_traveling = false
			audio_player.stop()
			audio_player.stream = sound_ferry_stop
			audio_player.play()

	move_and_slide()

func objective_reached():
	velocity = Vector2(0, 0)
	is_traveling = false
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
		player_car = body
		retrieve_player()
		is_traveling = true
		audio_player.stream = sound_ferry_start
		audio_player.play()
