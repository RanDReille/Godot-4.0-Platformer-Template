extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@export var ground_acceleration := 2000.0
@export var ground_static_friction := 800.0
@export var ground_dynamic_friction := 4.0

@export var air_acceleration := 1000.0
@export var air_static_friction := 400.0
@export var air_dynamic_friction := 3.0

@export var ground_submerged_acceleration := 1500.0
@export var ground_submerged_static_friction := 1200.0
@export var ground_submerged_dynamic_friction := 6.0

@export var submerged_acceleration := 1000.0
@export var submerged_static_friction := 600.0
@export var submerged_dynamic_friction := 4.0

@export var jump_speed := 400.0
@export var max_jump_stamina := 0.2
@export var coyote_time = 0.05
@export var input_jump_memory_time = 0.1

@export var splash_min_delay = 0.2
@export var splash_check_delay = 0.1
@export var platform_disable_delay = 0.2

@onready var anim_state_machine = $AnimationTree.get("parameters/playback")

#var feet_submerged := false
#var head_submerged := false
var submerged := false
var last_submerged := false
var splash_timer = 0.0
var splash_check_timer = 0.0
var platform_disable_timer := 0.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var current_state = null

@onready var body = $body

@onready var states_map = {
	'idle': $States/Idle,
	'run': $States/Run,
	'air': $States/Air
}

#inputs
var input_horizontal : int = 0
var input_jump : bool = false
var input_just_jump : bool = false
var input_jump_memory : float = 0.0
var input_down : bool = false
var jump_stamina = 0

func _ready():
	Global.player = self
	current_state = states_map['air']
	current_state.enter(self)

func _physics_process(delta):
	last_submerged = submerged
	get_input()
	input_jump_memory = Global.timer_countdown(input_jump_memory, delta)
	submerged = $Water_Check.has_overlapping_bodies()
	if submerged && !last_submerged && velocity.y >= 0:
		splash_submerge(true)
	elif !submerged && last_submerged && velocity.y <= 0:
		splash_submerge(false)
	
	splash_check_timer = Global.timer_countdown(splash_check_timer, delta)
	if platform_disable_timer <= delta && platform_disable_timer > 0:
		set_collision_mask_value(3, true)
	platform_disable_timer = Global.timer_countdown(platform_disable_timer, delta)
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	move_and_slide()
	
	var new_state_name = current_state.physics_update(self, delta)
	if new_state_name:
		change_state(new_state_name)
	
	


func get_input():
	input_horizontal = Input.get_axis("action_left", "action_right")
	input_jump = Input.is_action_pressed("action_jump")
	input_just_jump = Input.is_action_just_pressed("action_jump")
	input_down = Input.is_action_pressed("action_down")

func change_state(new_state_name):
	current_state.exit(self)
	current_state = states_map[new_state_name]
	current_state.enter(self)

func platform_disable():
	set_collision_mask_value(3, false)
	platform_disable_timer = platform_disable_delay

func splash_submerge(enter := false):
	Global.instant_particles("splash", global_position + Vector2(0.0, 24.0))
	if enter:
		Global.play_SFX("water_submerge")
	else:
		Global.play_SFX("water_splash")
