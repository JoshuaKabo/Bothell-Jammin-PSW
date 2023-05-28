extends CharacterBody2D

const SPEED = 300.0
var timer

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var despawn_timer

func _ready():
	despawn_timer = get_node("despawn_timer")
	despawn_timer.start()

func _physics_process(_delta):
	# apply the valocity as supplied from the start
	move_and_slide()


func _on_despawn_timer_timeout():
	# delete when timer runs out
	queue_free()
