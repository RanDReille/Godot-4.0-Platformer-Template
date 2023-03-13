extends Node

const SCREEN_WIDTH = 640
const SCREEN_HEIGHT = 360

const STAGES = {
	"w0": preload("res://Game Assets/Stages/Worlds/world_0.tscn"),
	"w1": preload("res://Game Assets/Stages/Worlds/world_1.tscn")
}

const SFX = {
	"jump": preload("res://Game Assets/SFX/Jump.wav"),
	"water_splash": preload("res://Game Assets/SFX/Water_Splash.wav"),
	"water_submerge": preload("res://Game Assets/SFX/Water_Submerge.wav")
}

const BGM = {
	
}

const INSTANT_PARTICLES = {
	"splash": preload("res://Game Assets/GPUParticles/splash.tscn")
}

@onready var SFX_Player = preload("res://Game Assets/SFX/sfx_player.tscn")

var game = null
var player = null

var start_pos = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func timer_countdown(value, delta):
	if value > delta:
		return value - delta
	else:
		return 0

func play_SFX(SFX_name):
	var new_SFX_Player = SFX_Player.instantiate()
	game.add_child(new_SFX_Player)
	new_SFX_Player.stream = SFX[SFX_name]
	new_SFX_Player.play()

func instant_particles(particle_name, location):
	var new_particle = INSTANT_PARTICLES[particle_name].instantiate()
	game.current_stage_node.add_child(new_particle)
	new_particle.global_position = location
	
