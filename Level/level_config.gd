extends Node

@export var LEVEL_TIMER: float = 2 * 60.0

@export var level_id: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_level_timer_timeout():
	Globals.finish_level(level_id)
