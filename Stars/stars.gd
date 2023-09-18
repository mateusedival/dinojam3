extends CharacterBody2D


@export var GRAVITY: float = 200.0
@export var SPEED: float = 300.0
@export var JUMP_FORCE: float = 630.0
@export var ACC: float = 150.0

var is_jumping = false



# Called when the node enters the scene tree for the first time.
func _ready():
	$Hitbox/CollisionShape2D.disabled = true
	$jumping.visible = false


func _physics_process(delta):
	if is_jumping:
		velocity.x = move_toward(velocity.x, -SPEED , ACC * delta)
		velocity.y += GRAVITY * delta
		$walking.visible = false
		$jumping.visible = true

	move_and_slide()
	
func jump():
	$Hitbox/CollisionShape2D.disabled = false
	velocity.y = -JUMP_FORCE
	is_jumping = true
	
func add_variation(jump_var,speed_var):
	JUMP_FORCE += jump_var
	SPEED += speed_var

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _on_timer_timeout():
	jump()

func funcking_dies():
	Globals.score_updater(1)
	queue_free()


func _on_hitbox_body_entered(body):
	funcking_dies()
