extends CharacterBody2D

# Notes:
# Modification of Godot Recipes: Car Steering - https://www.youtube.com/watch?v=mJ1ZfGDTMCY&t=193s
# This car follows a 2 wheel model, where the front wheel steers, and the back wheel drives forward / backward.

# how far apart the steer and drive wheels are
var wheel_base = 70
# how far the front wheel can turn in degrees
var steering_angle_max = 15
# for how quickly the car can accelerate
var engine_power = 800

# for surface friction, like driving on sand
var friction = -0.9
# drag will be based on square of velocity, so it will be more noticeable at higher speeds, small value
var drag = -0.001

var steer_direction

var acceleration = Vector2.ZERO
# braking - decceleration
var braking = -450
# how fast you can reverse
var max_speed_reverse = 250


func _physics_process(delta):
	acceleration = Vector2.ZERO
	get_input()
	apply_friction()
	calculate_steering(delta)

	velocity += acceleration * delta
	# apply movement from velocity TODO: unsure if this still applies
	move_and_slide()

func apply_friction():
	# friction slows us down, 
	if velocity.length() < 5:
		velocity = Vector2.ZERO
	
	# friction is negative, force in the opposite direction of velocity
	var friction_force = velocity * friction
	# get proportional to the velocity squared
	var drag_force = velocity * velocity.length_squared() * drag
	# apply the forces
	acceleration += drag_force + friction_force

	# apply friction to velocity
	velocity *= friction
	# apply drag to velocity
	velocity -= velocity * velocity.length_squared() * drag

func get_input():
	# turn is zero with no directional input
	var turn = 0
	if Input.is_action_pressed("steer_right"):
		turn += 1
	if Input.is_action_pressed("steer_left"):
		turn -= 1
	# apply the steer direction
	steer_direction = turn * deg_to_rad(steering_angle_max)

	if Input.is_action_pressed("accelerate"):
		acceleration = transform.x * engine_power
	if Input.is_action_pressed("brake"):
		acceleration = transform.x * braking


func calculate_steering(delta):
	# offset the rear and front wheels from the center of the car
	var rear_wheel = position - transform.y * wheel_base / 2.0
	var front_wheel = position + transform.y * wheel_base / 2.0

	# apply velocity to the rear wheel, and apply the rotated velocity to the front wheel
	rear_wheel += velocity * delta
	front_wheel += velocity.rotated(steer_direction) * delta

	# apply new facing direction using vector subtraction of the wheels, then get the angle
	var new_heading = (front_wheel - rear_wheel).normalized()
	# handle braking becomes reversing
	var d = new_heading.dot(velocity.normalized())
	if d > 0:
		# forward
		velocity = new_heading * velocity.length()
	if d < 0:
		# reverse
		velocity = -new_heading
	rotation = new_heading.angle()

