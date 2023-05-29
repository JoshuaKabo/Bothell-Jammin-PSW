extends CharacterBody2D

const SPEED = 300.0
const FLAME_SPEED = 450.0
# const ACCELERATION

@export var wander_range = 100



@export var on_fire: bool = false
@export var mobile: bool = false

@export var mobile_sprite: Texture2D
@export var stationary_sprite: Texture2D

var flamesprite
var character_sprite
# @export var character_sprite: Sprite2D

# run might be too much work for 
# enum { WANDER, RUN }


func _ready():
	flamesprite = get_node("flamesprite")
	character_sprite = get_node("charactersprite")

	if on_fire:
		flamesprite.visible = true
	else:
		flamesprite.visible = false

	if mobile:
		character_sprite.set_texture(mobile_sprite)
	else:
		character_sprite.set_texture(stationary_sprite)



# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func set_fire_status(flame_state):
	on_fire = flame_state
	flamesprite.visible = flame_state



# func accelerate_towards_point(point, delta):
# 	var direction = global_position.direction_to(point)
# 	# move towards player, vector, amount
# 	velocity = velocity.move_toward(direction * MAXSPEED, ACCELERATION * delta)
# 	sprite.flip_h = velocity.x < 0


# func _physics_process(_delta):
# 	var speed = 0
# 	# speed = on_fire ? FLAME_SPEED : SPEED
# 	# if on_fire:
# 	# 	speed = 

# 	if mobile:
# 		accelerate_towards_point(wander_controller.target_pos, delta)

# 		# don't readjust a whole bunch when you hit the target (if set to 0, they shimmey)
# 		if global_position.distance_to(wander_controller.target_pos) <= wander_target_adjust:
# 			check_for_new_state()
		# wander within wander_range
		# var direction = rand_range(-1, 1)
		# if direction == 0:
		# 	direction = 1
		# var velocity = Vector2(direction * SPEED, 0)
		# move_and_slide(velocity)


# func _physics_process(delta):
# 	# Add the gravity.
# 	if not is_on_floor():
# 		velocity.y += gravity * delta

# 	# Handle Jump.
# 	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
# 		velocity.y = JUMP_VELOCITY

# 	# Get the input direction and handle the movement/deceleration.
# 	# As good practice, you should replace UI actions with custom gameplay actions.
# 	var direction = Input.get_axis("ui_left", "ui_right")
# 	if direction:
# 		velocity.x = direction * SPEED
# 	else:
# 		velocity.x = move_toward(velocity.x, 0, SPEED)

# 	move_and_slide()
	
