extends Node2D

@export var Star: Resource
@export var Indicator: Resource


@export var spawn_rate: float = 3.0

@export var length: int = 500.0


@export var jump_variation: float = 200.0

@export var speed_variation: float = 80.0

@export var on: bool = true


# Called when the node enters the scene tree for the first time.
func _ready():
	if on:
		$Timer.start(spawn_rate)
	
	

func spawn_indicator():
	var indicator = Indicator.instantiate()
	
	# TODO: remove magic number
	var x = randi_range(global_position.x - length, global_position.x -20)
	
	indicator.global_position = Vector2(x,global_position.y - 60)
	
	indicator.connect('spawn_ready',spawn_star)
	
	
	get_tree().root.add_child(indicator)
	
	pass
	
func spawn_star(x: int):
	var star = Star.instantiate()
	

	star.global_position = Vector2(global_position.x ,global_position.y - 50)
	
	var speed = randf_range(-speed_variation, 0)
	var jump = randf_range(-jump_variation,jump_variation)
	
	star.add_variation(speed,jump)
	
	var tween = create_tween()
	
	get_tree().root.add_child(star)
	
	tween.tween_property(star, "global_position", Vector2(x,star.global_position.y), 2).set_trans(Tween.TRANS_QUAD)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_timer_timeout():
	spawn_indicator() # Replace with function body.
