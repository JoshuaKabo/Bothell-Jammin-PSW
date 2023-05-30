extends Camera2D


@export var player_car: Node2D

@export var initial_tracker: Node2D
@export var goal_pos: Node2D
@export var initialzoom: float = 1.0
@export var goalzoom: float = 0.1

@export var zoom_timer: Timer

@export var zoomTime: float = 3.0
@export var holdTime: float = 6.0


var smoothing = 0.1

# i'd do an enum if I weren't lazy
var zoomphase = 0

var active = false


# Called when the node enters the scene tree for the first time.
# func _ready():
# 	global_position = initial_tracker.get_global_position()

func handle_transition():
	make_current()
	active = true
	zoom_timer.start(zoomTime)


func _process(_delta):
	if(active):
		# print("active")
		if(zoomphase == 0):
			# print("zooming out")
			var position_step = lerp(goal_pos.global_position, initial_tracker.global_position, zoom_timer.time_left / zoomTime)
			global_position = position_step

			var zoomamt = lerp(goalzoom, initialzoom, zoom_timer.time_left / zoomTime)
			set_zoom(Vector2(zoomamt, zoomamt))

		elif(zoomphase == 2):
			# print("zooming in")
			var position_step = lerp( initial_tracker.global_position, goal_pos.global_position, zoom_timer.time_left / zoomTime)
			global_position = position_step

			var zoomamt = lerp(initialzoom, goalzoom, zoom_timer.time_left / zoomTime)
			set_zoom(Vector2(zoomamt, zoomamt))


func _on_zoom_timer_timeout():
	# begin hold
	if (zoomphase == 0):
		zoom_timer.start(holdTime)
		zoomphase = 1

	# begin zoom in
	elif(zoomphase == 1):
		zoom_timer.start(zoomTime)
		zoomphase = 2
		
	# begin
	elif(zoomphase == 2):
		player_car.reclaim_cam()
		active = false
		zoomphase = -1



#  I need it to swap 
