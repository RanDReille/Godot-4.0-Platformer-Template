extends Node

@onready var stage = get_node("%Stage")

var current_stage : String = ""
var current_stage_node

@onready var stage_transition = $Stage_Transition_Player
var transition_stage_name : String = ""
var transition_start_pos : int = 0
var transition_offset_pos : Vector2 = Vector2(0, 0)
var transition_velocity : Vector2 = Vector2(0, 0)
var transition_jump_stamina : float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.game = self
	set_stage("w0")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_stage(stage_name):
	var child_count = stage.get_child_count()
	if child_count > 0:
		var children = stage.get_children()
		for child in children:
			child.queue_free()
	var new_stage = Global.STAGES[stage_name].instantiate()
	stage.add_child(new_stage)
	current_stage_node = new_stage
	
	current_stage = stage_name
#	print_debug(stage_name.left(1))
	if stage_name.left(1) == "w":
		play_BGM(new_stage.BGM)
	else:
		Global.player = null

func set_stage_transition():
	set_stage(transition_stage_name)

func play_BGM(BGM_name):
	if BGM_name != "":
		$BGM_Player.stream = Global.BGM[BGM_name]
		$BGM_Player.play()
	else:
		$BGM_Player.stop()
