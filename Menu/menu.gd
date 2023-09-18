extends CanvasLayer


@export var next_scene: String = ''
const FadeOut = preload("res://UI/fadeOut.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("ui_accept"):
		var fade_out = FadeOut.instantiate()
		fade_out.connect('finished',fade)
		add_child(fade_out)
		
		
func fade():
		get_tree().change_scene_to_file(next_scene)
