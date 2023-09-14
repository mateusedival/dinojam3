extends CharacterBody2D

@export var SPRITE: String = "baby"
@export var SPEED: float = 400.0
@export var ACC: float = 80.0
@export var FRICTION: float = 40.0

@export var IFRAMES: float = 10

@onready var DASH_SPEED: float = SPEED * 3

@onready var STATE = 'MOVE'

var is_dashing = true

var dash_direction: Vector2 = Vector2.ZERO



# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	var direction = Vector2.ZERO
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	direction.x = Input.get_axis("ui_left", "ui_right")
	direction.y = Input.get_axis('ui_up', 'ui_down')
	
	direction.normalized()
	
	if (Input.is_action_just_pressed("ui_accept")):
		start_dash(direction, delta)
	
	match STATE:
		'MOVE':
			move(direction)
		'DASH': 
			dash()
	
		
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
	STATE = 'DASH'
	$Echo.toggle(true,delta * 2)
	$Timer.start(0.2)

func dash():
	if dash_direction:
		velocity.x = move_toward(velocity.x, dash_direction.x * DASH_SPEED, ACC * 3)
		velocity.y = move_toward(velocity.y, dash_direction.y * DASH_SPEED, ACC * 3)
	else:	
		velocity.x = move_toward(velocity.x, 0, FRICTION * 3)
		velocity.y = move_toward(velocity.y, 0, FRICTION * 3)
		

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
		$Echo.create_echo($Sprite2D.texture, global_position,self.scale)

func _on_timer_timeout():
	is_dashing = false
	STATE = 'MOVE'
	$Echo.toggle(false,0)


func _on_player_stats_no_health():
	fucking_dies()


func _on_hurt_box_body_entered(body):
	$PlayerStats.health -= 1
	$HurtBox.start_invincibility(IFRAMES)
	print($PlayerStats.health)
