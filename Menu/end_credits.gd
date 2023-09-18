extends Control

@export var next_scene: String = ''

# Called when the node enters the scene tree for the first time.
func _ready():
	play_credits()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed('ui_accept'):
		get_tree().change_scene_to_file(next_scene)


func play_credits():
	$AnimationPlayer.play("Credits")
	
	
func play_credits_for():
	$AnimationPlayer.play("CreditsFor")
	

func play_final():
	$AnimationPlayer.play("FInalPhrase")
