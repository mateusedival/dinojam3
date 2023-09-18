extends Timer


@export var spawn_rate: float = 0.1
@export var on: bool = false
@export var fade_out = 0.7


func toggle(_on: bool, delta: float):
	if(!_on):
		self.stop()
		return
	self.start(delta)


func create_echo(echo_texture: Texture, pos: Vector2, echo_scale: Vector2 = Vector2(1,1)):
	var echo = Sprite2D.new()
	echo.texture = echo_texture
	echo.global_position = pos
	echo.scale = echo_scale
	var tween = create_tween()
	add_child(echo)
	
	tween.tween_property(echo,'modulate',Color(1,1,1,0),fade_out)
	tween.connect('finished',echo.queue_free)
	
	
	

