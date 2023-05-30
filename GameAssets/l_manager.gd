extends Node2D

@export var win_text: Label
@export var lose_text: Label
@export var end_text: Label

@export var lose_fire_1: Node2D
@export var lose_fire_2: Node2D
@export var lose_fire_3: Node2D

@export var points_to_win_1: int
@export var points_to_win_2: int
@export var points_to_win_3: int

@export var win: AudioStream
@export var bad: AudioStream

var audio_player

var phase = 1


@export var hold_dur: float = 5.0

var text_timer

var points: int = 0

func _ready():
	text_timer = get_node("Timer")
	audio_player = get_node("AudioStreamPlayer")

func update_points(num):
	points += num


func present_to_player():

	text_timer.start(hold_dur)

	match(phase):
		1:
			if(points >= points_to_win_1):
				win_text.show()
				audio_player.stream = win
				audio_player.play()
			else:
				lose_text.show()
				lose_fire_1.show()
				audio_player.stream = bad
				audio_player.play()
			phase +=1
		2:
			if(points >= points_to_win_2):
				win_text.show()
				audio_player.stream = win
				audio_player.play()
			else:
				lose_text.show()
				lose_fire_2.show()
				audio_player.stream = bad
				audio_player.play()
			phase +=1

		3:
			if(points >= points_to_win_3):
				end_text.show()
				audio_player.stream = win
				audio_player.play()
			else:
				end_text.show()
				lose_fire_3.show()
				audio_player.stream = bad
				audio_player.play()
			phase +=1



func _on_timer_timeout():
	lose_text.hide()
	win_text.hide()

