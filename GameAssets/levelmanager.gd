extends Label


@export var lvTime = 10.0
@export var lv2Time = 20.0

var leveltimer


# Called when the node enters the scene tree for the first time.
func _ready():
	leveltimer = get_node("leveltimer")
	leveltimer.start(lvTime)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	text = "Time Remaining: " + str("%2.1f" % leveltimer.time_left)
