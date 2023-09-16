extends CharacterBody2D

@export var SPRITE: String = "baby"
@export var SPEED: float = 400.0
@export var ACC: float = 80.0
@export var FRICTION: float = 40.0

@export var IFRAMES: float = 1

@onready var DASH_SPEED: float = SPEED * 2.3
@export var DASH_TIMER: float = 0.2
@export var DASH_COOLDOWN: float = 2

@export var PARRY_TIMER: float = 0.1
@export var PARRY_COOLDOWN: float = 0.5

@onready var STATE: States = States.MOVE

enum States {MOVE,DASH,PARRY}

var is_dashing = false
var is_parrying = false

var dash_direction: Vector2 = Vector2.ZERO


func _ready():
	$DamageBox/CollisionShape2D.disabled = true

func _physics_process(delta):
	var direction = Vector2.ZERO
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	direction.x = Input.get_axis("ui_left", "ui_right")
	direction.y = Input.get_axis('ui_up', 'ui_down')
	
	direction.normalized()
	
	if (Input.is_action_just_pressed("dash")) and !is_dashing:
		start_dash(direction, delta)
	elif (Input.is_action_just_pressed("parry")) and !is_parrying:
		STATE = States.PARRY

	match STATE:
		States.MOVE:
			move(direction)
		States.DASH: 
			dash()
		States.PARRY:
			parry()
	
		
	#print(velocity)
	
	animator(SPRITE)
	
	move_and_slide()
	
	
func move(direction: Vector2):
	if direction:
		velocity.x = move_toward(velocity.x, direction.x * SPEED, ACC)
		velocity.y = move_toward(velocity.y, direction.y * SPEED, ACC)
	else:
		velocity.x = move_toward(velocity.x, 0, FRICTION)
		velocity.y = move_toward(velocity.y, 0, FRICTION)
	
func start_dash(direction, delta):
	dash_direction = direction
	is_dashing = true
	STATE = States.DASH
	$Echo.toggle(true,delta * 2)
	$DashTimer.start(DASH_TIMER)
	$HurtBox.start_invincibility(DASH_TIMER + 0.1)

func dash():
	if dash_direction:
		velocity.x = move_toward(velocity.x, dash_direction.x * DASH_SPEED, ACC * 3)
		velocity.y = move_toward(velocity.y, dash_direction.y * DASH_SPEED, ACC * 3)
	else:	
		velocity.x = move_toward(velocity.x, 0, FRICTION * 3)
		velocity.y = move_toward(velocity.y, 0, FRICTION * 3)
		
func parry():
	if !is_parrying:
		$DamageBox/CollisionShape2D.disabled = false
		is_parrying = true
		$ParryTimer.start(PARRY_TIMER)


func animator(player_type):
	if player_type == "female":
		$baby_sprite.visible   = false
		$mom_sprite.visible    = false
		$female_sprite.visible = true
		if velocity.y < 0:
			$female_sprite.play('up')
		elif velocity.y > 0 and velocity.x >= 0:
			$female_sprite.play('down')
		elif velocity.x < 0:
			$female_sprite.play('back')
		else:
			$female_sprite.play('idle')
	
	if player_type == "mom":
		$baby_sprite.visible   = false
		$mom_sprite.visible    = true
		$female_sprite.visible = false
		if velocity.y < 0:
			$mom_sprite.play('up')
		elif velocity.y > 0 and velocity.x >= 0:
			$mom_sprite.play('down')
		elif velocity.x < 0:
			$mom_sprite.play('back')
		else:
			$mom_sprite.play('idle')
	
	if player_type == "baby":
		$baby_sprite.visible   = true
		$mom_sprite.visible    = false
		$female_sprite.visible = false
		
		$baby_sprite.play("default")
		
func fucking_dies():
	queue_free()


func _on_echo_timeout():
	if(velocity != Vector2.ZERO):
		if SPRITE == "mom":
			var frame_idx = $mom_sprite.frame
			var animation_name = $mom_sprite.animation
			$Echo.create_echo($mom_sprite.sprite_frames.get_frame_texture(animation_name,frame_idx), global_position,self.scale)
		elif SPRITE == "baby":
			var frame_idx = $baby_sprite.frame
			var animation_name = $baby_sprite.animation
			$Echo.create_echo($baby_sprite.sprite_frames.get_frame_texture(animation_name,frame_idx), global_position,self.scale)
		elif SPRITE == "female":
			var frame_idx = $female_sprite.frame
			var animation_name = $female_sprite.animation
			$Echo.create_echo($female_sprite.sprite_frames.get_frame_texture(animation_name,frame_idx), global_position,self.scale)
		

func _on_timer_timeout():
	$DashCooldown.start(DASH_COOLDOWN)
	STATE = States.MOVE
	$Echo.toggle(false,0)


func _on_player_stats_no_health():
	fucking_dies()


func _on_hurt_box_body_entered(body):
	$PlayerStats.health -= 1
	$HurtBox.start_invincibility(IFRAMES)
	print($PlayerStats.health)


func _on_parry_timer_timeout():
	STATE = States.MOVE
	$DamageBox/CollisionShape2D.disabled = true
	$ParryCooldown.start(PARRY_COOLDOWN)


func _on_parry_cooldown_timeout():
	is_parrying = false


func _on_dash_cooldown_timeout():
	is_dashing = false
