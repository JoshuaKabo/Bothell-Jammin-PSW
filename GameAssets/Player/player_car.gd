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
var drag = -0.0015

var steer_angle

var acceleration = Vector2.ZERO
# braking - decceleration
var braking = -450
# how fast you can reverse
var max_speed_reverse = 250

# REGION drift / slide
# speed where we start to drift, traction loss
var slip_speed = 400
# high speed traction
var traction_fast = 0.1
# low speed traction
var traction_slow = 0.7
# END REGION


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
	var drag_force = velocity * velocity.length() * drag
	# if we are going slow, increase the friction, no creep forward
	if(velocity.length() < 100):
		friction_force *= 3
	# apply the forces
	acceleration += drag_force + friction_force

func get_input():
	# turn is zero with no directional input
	var turn_dir = 0
	if Input.is_action_pressed("steer_right"):
		turn_dir += 1
	if Input.is_action_pressed("steer_left"):
		turn_dir -= 1
	# apply the steer direction
	steer_angle = turn_dir * deg_to_rad(steering_angle_max)

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
	front_wheel += velocity.rotated(steer_angle) * delta

	# apply new facing direction using vector subtraction of the wheels, then get the angle
	var new_heading = (front_wheel - rear_wheel).normalized()
	var traction = traction_slow
	if velocity.length() > slip_speed:
		traction = traction_fast
	# handle braking becomes reversing
	var d = new_heading.dot(velocity.normalized())
	if d > 0:
		# forward
		velocity = velocity.lerp(new_heading * velocity.length(), traction)
	if d < 0:
		# reverse
		velocity = -new_heading * min(velocity.length(), max_speed_reverse)
	rotation = new_heading.angle()

