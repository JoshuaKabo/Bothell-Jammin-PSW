extends Node2D

@export var win_text: Node2D
@export var lose_text: Node2D

@export var lose_fire: Node2D

@export var win_fire: Node2D

@export var points_to_win: int


@export var hold_dur: float = 5.0

var points: int = 0

func update_points(num):
	print("points 1")
	points += num


func present_to_player():
	if(points >= points_to_win):
		win_text.show()
	else:
		lose_text.show()
		lose_fire.show()
