extends Camera2D


@export var initial_tracker: Node2D
@export var goal_pos: Node2D
@export var initialzoom: float = 1.0
@export var goalzoom: float = 0.1

var smoothing = 0.1


# Called when the node enters the scene tree for the first time.
func _ready():
	global_position = initial_tracker.global_position
	# set_follow_target(target_node)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
