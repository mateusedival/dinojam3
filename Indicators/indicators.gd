extends Sprite2D

signal spawn_ready(x: int)

func _ready():
	$AnimationPlayer.play("Blink")


func _on_timer_timeout():
	emit_signal('spawn_ready', int(global_position.x))
	queue_free()
