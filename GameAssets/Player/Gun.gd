extends Node2D

var fire_point
var water_drop_scene = preload("res://water_drop.tscn")
var fire_rate_timer
var audio_player_camera_effected
@export var fire_rate = 10.0
@export var fire_volume_db = 0.0
@export var sound_start_fire: AudioStream
@export var sound_fire_loop: AudioStream
@export var sound_cease_fire: AudioStream


# Called when the node enters the scene tree for the first time.
func _ready():
	audio_player_camera_effected = get_node("AudioStreamPlayer2D")
	audio_player_camera_effected.volume_db = fire_volume_db
	fire_point = get_node("firepoint")
	fire_rate_timer = get_node("firetimer")


func handle_fire():
	# print(fire_rate_timer.time_left)

	# start the init sound effect

	# check if the fire rate timer is ready
	if fire_rate_timer.is_stopped():

		# restart the fire rate timer (1/firerate for rapid)
		fire_rate_timer.start(1/fire_rate)

		# instatiate and context
		var level_scene = get_tree().current_scene
		var fired_drop = water_drop_scene.instantiate()

		# fire drop transform stuff
		fired_drop.global_position = fire_point.global_position
		fired_drop.global_rotation = global_rotation
		fired_drop.velocity = Vector2(1, 0).rotated(global_rotation) * 1000

		# add the drop to the scene
		level_scene.add_child(fired_drop)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	# Get the position of the mouse relative to the node
	var mouse_pos = get_global_mouse_position() - global_position
	
	# Calculate the angle between the node and the mouse
	var angle = atan2(mouse_pos.y, mouse_pos.x)
	
	# Set the node's global rotation to the calculated angle - global for not being messed up by car rotation
	global_rotation = angle
	if Input.is_action_just_pressed("fire"):
		audio_player_camera_effected.stream = sound_start_fire
		audio_player_camera_effected.play()
		# audio_player_camera_effected.stream = sound_fire_loop
		# audio_player_camera_effected.play()
		# play the start fire sound effect
		# pass

	if Input.is_action_pressed("fire"):
		handle_fire()

	if Input.is_action_just_released("fire"):
		audio_player_camera_effected.stop()
		# play the ceasefire sound effect
		audio_player_camera_effected.stream = sound_cease_fire
		audio_player_camera_effected.play()



# on sound effect ended


func _on_audio_stream_player_2d_finished():
	# continue to loop the fire sound effect
	if(Input.is_action_pressed("fire")):
		audio_player_camera_effected.stream = sound_fire_loop
		audio_player_camera_effected.play()
