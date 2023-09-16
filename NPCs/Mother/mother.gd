extends CharacterBody2D


var next_point: Vector2 = Vector2.ZERO

enum States {WANDER, PROTECT, STILL}

@export var state: States = States.WANDER

@export var STILL_TIME: float = 3.0

@onready var max_width = ProjectSettings.get_setting("display/window/size/viewport_width")
@onready var max_height = ProjectSettings.get_setting("display/window/size/viewport_height")

var is_wandering: bool = false
var is_still: bool = false
var is_protecting: bool = false

@export var movement_time: float = 2.0



func _ready():
	#$Sprite2D.play("default")
	$CollisionShape2D.disabled = true
	
	


func _physics_process(delta):
	match state:
		States.WANDER:
			wander()
		States.PROTECT: 
			protect(delta)
		States.STILL:
			still()

func wander():
	if !is_wandering:
		var start_point = get_random_screen_point()
		
		var end_point = start_point + Vector2(300,0)

		var tween: Tween = create_tween()
		
		var current_position = get_global_position()
		
		# esse é o vetor de direção KK 
		var edival_eh_lindo = current_position.direction_to(start_point)
		
		if edival_eh_lindo.y < 0:
			$mom_npc.play("up")
			$Timer.start(movement_time)
		elif edival_eh_lindo.y > 0 and edival_eh_lindo.x >= 0:
			$mom_npc.play("down")
			$Timer.start(movement_time)
		elif edival_eh_lindo.x < 0:
			$mom_npc.play("back")
			$Timer.start(movement_time)
		else:
			$mom_npc.play("idle")
			$Timer.start(movement_time)
		
		tween.connect('finished',set_wander)
		
		tween.tween_property(self,'global_position',start_point,movement_time)
		tween.tween_property(self,'global_position',end_point,(movement_time+1))
		is_wandering = true
		
	
func set_wander():
	is_wandering = false
	state = get_next_state()
	
func still():
	if !is_still:
		$mom_npc.play("idle")
		$StillTimer.start(STILL_TIME)
		is_still = true
	
	
func protect(delta):
	if !is_protecting:
		var y = randi_range(0+200,max_height-200)
		
		var start_point = Vector2(0,y)
		var end_point = start_point + Vector2(max_width,0)
		
		is_protecting = true
		
		var tween = create_tween()
		
		tween.connect('finished',set_protect)
		
		tween.connect('step_finished',enable_protect)
		
		var current_position = get_global_position()
		var edival_eh_lindo = current_position.direction_to(start_point)
		
		if edival_eh_lindo.y < 0:
			$mom_npc.play("up")
			$Timer.start(movement_time)
		elif edival_eh_lindo.y > 0 and edival_eh_lindo.x >= 0:
			$mom_npc.play("down")
			$Timer.start(movement_time)
		elif edival_eh_lindo.x < 0:
			$mom_npc.play("back")
			$Timer.start(movement_time)
		else:
			$mom_npc.play("idle")
			$Timer.start(movement_time)
		
		tween.tween_property(self,'global_position',start_point,movement_time)
		tween.tween_property(self,'global_position',end_point,(movement_time+1))
		
		tween.connect("step_finished",echo_dash)
		# TODO: FAZER O ECHO SÓ QUANDO A BICHA VAI PRA FRENTE
		
		
func echo_dash(idx):
	if idx == 0:
		$Echo.toggle(true,0.16 * 2)
		
func enable_protect(idx: int):
	if idx == 0:
		#$Sprite2D.play("protect")
		$CollisionShape2D.disabled = false
	
func set_protect():
	is_protecting = false
	#$Sprite2D.play("default")
	$CollisionShape2D.disabled = true
	$Echo.toggle(false,0)
	state = States.WANDER

func get_next_state() -> States:
	var random_float = randf()

	if random_float < 0.5:
		# 80% chance of being returned.
		return States.STILL
	elif random_float < 0.8:
		# 15% chance of being returned.
		return States.WANDER
	else:
		# 5% chance of being returned.
		return States.PROTECT

func get_random_screen_point() -> Vector2:
	var x = randi_range(300,max_width-300)
	var y = randi_range(300,max_height-300)
	
	return Vector2(x,y)

func _on_still_timer_timeout():
	is_still = false
	state = get_next_state()


func _on_movement_timeout():
	$mom_npc.play('idle')


func _on_echo_timeout():
	var frame_idx = $mom_npc.frame
	var animation_name = $mom_npc.animation
	$Echo.create_echo($mom_npc.sprite_frames.get_frame_texture(animation_name,frame_idx), global_position,self.scale)
