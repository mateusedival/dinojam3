extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.connect("score_update",set_score)


func set_score(score: int):
	$Score.text = str(score)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
