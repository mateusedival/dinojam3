extends CanvasLayer

signal finished
# Called when the node enters the scene tree for the first time.
func _ready():
	var tween = create_tween()
	tween.connect('finished',finished_at_last)
	tween.tween_property($ColorRect,'color',Color(0,0,0,0),2).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_LINEAR)


func finished_at_last():
	emit_signal('finished')
	queue_free()
