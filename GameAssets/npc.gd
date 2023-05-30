extends CharacterBody2D

const SPEED = 300.0
const FLAME_SPEED = 450.0
const ACCELERATION = 300
const FLAME_ACCELERATION = 400


@export var on_fire: bool = false
@export var mobile: bool = false
@export var is_boss: bool = false
@export var hp_boss: int = 10

@export var mobile_sprite: Texture2D
@export var stationary_sprite: Texture2D

var flamesprite
var character_sprite
var wander_controller
var sound_maker

@export var wander_target_jimmy = 4


func _ready():
	wander_controller = get_node("wander_controller")
	flamesprite = get_node("flamesprite")
	character_sprite = get_node("charactersprite")
	sound_maker = get_node("sound_maker")

	if on_fire:
		flamesprite.visible = true
	else:
		flamesprite.visible = false

	if mobile:
		character_sprite.set_texture(mobile_sprite)
	else:
		character_sprite.set_texture(stationary_sprite)

	wander_controller.start_wander_timer(randf_range(0.5, 4.0))



# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func set_fire_status(flame_state):
	on_fire = flame_state
	flamesprite.visible = flame_state



func accelerate_towards_point(point, speed, acceleration, delta):
	var direction = (point - global_position).normalized()

	# move towards player, vector, amount
	velocity = velocity.move_toward(direction * speed, acceleration * delta)
	move_and_slide()


func _physics_process(delta):
	# print("npc: %s" % collision_mask)
	var applied_speed = SPEED
	var applied_accel = ACCELERATION

	if on_fire:
		applied_speed = FLAME_SPEED	
		applied_accel = FLAME_ACCELERATION

	if mobile:
		accelerate_towards_point(wander_controller.get_target_pos(), applied_speed, applied_accel, delta)

		# don't readjust a whole bunch when you hit the target (if set to 0, they shimmey)
		if global_position.distance_to(wander_controller.get_target_pos()) <= wander_target_jimmy:
			wander_controller.start_wander_timer(randf_range(0.5, 4.0))


func extinguish():
	get_tree().get_root().get_child(0).find_child("l_manager").update_points(1)
	set_fire_status(false)
	sound_maker.play()

func update_hp():
	if(is_boss):
		hp_boss -= 1
		if(hp_boss <= 0):
			extinguish()

	# pass # Replace with function body.


func _on_hurtbox_body_entered(body):
	if(on_fire and not is_boss):
		extinguish()
	elif(is_boss and on_fire):
		update_hp()
	# pass # Replace with function body.
