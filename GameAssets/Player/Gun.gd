extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    # Get the position of the mouse relative to the node
	var mouse_pos = get_global_mouse_position() - global_position
    
    # Calculate the angle between the node and the mouse
	var angle = atan2(mouse_pos.y, mouse_pos.x)
    
    # Set the node's global rotation to the calculated angle - global for not being messed up by car rotation
	global_rotation = angle
