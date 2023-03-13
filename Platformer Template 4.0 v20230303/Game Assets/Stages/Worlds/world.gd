@tool
extends Node2D

@export var world_length : int = 1
@export var world_height : int = 1

@export var BGM : String = ""

@onready var player_camera = $Player/Camera_Dragger/Player_Camera

func _ready():
	var current_start_pos = $Start_Pos.get_child(Global.game.transition_start_pos)
	$Player.global_position = current_start_pos.global_position + Global.game.transition_offset_pos
	#print_debug(Global.game.transition_offset_pos)
	$Player.body.scale.x = current_start_pos.scale.x
	$Player.velocity = Global.game.transition_velocity
	$Player.jump_stamina = Global.game.transition_jump_stamina

func _physics_process(delta):
	if Engine.is_editor_hint():
		player_camera.limit_right = world_length*Global.SCREEN_WIDTH
		player_camera.limit_bottom = world_height*Global.SCREEN_HEIGHT
	pass
