extends CharacterBody2D


@export var SPEED: float = 300.0

func _ready():
	pass
	
func _physics_process(delta):

	velocity.x = -1 * SPEED
	#velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
func funcking_dies():
	queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func _on_hurtbox_body_entered(body):
	funcking_dies()


func _on_hurtbox_area_entered(area):
	funcking_dies()
