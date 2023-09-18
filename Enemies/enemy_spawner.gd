extends Node2D

@export var Enemy: Resource
@export var qnt_spawns: int = 3
@export var pos_ini: int = 0

# TODO: Get the screen size
@export var pos_final: int = 1000
@onready var length = pos_final - pos_ini
var spawns: Array = []

@export var spawn_rate: float = 2.0
@onready var max_enemies: int = qnt_spawns - 1 
@export var min_enemies: int = 1

@export var enemy_y_variance: float = 60.0
@export var enemy_x_variance: float = 0.0

@export var on = true
 

# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.start(spawn_rate)
	
	
	
	var chunk_size = int(length/qnt_spawns)
	
	for i in range(qnt_spawns):
		
		var marker = Marker2D.new()
		# TODO: get mid position
		marker.global_position = global_position

		marker.position.y =  (i * chunk_size) + int(chunk_size/2)
		spawns.push_back(marker)
		
		


func spawn_enemy(pos: Vector2):
	var new_enemy = Enemy.instantiate()
	new_enemy.position = pos
	
	var y_variance = randf_range(-enemy_y_variance,enemy_y_variance)
	var x_variance = randf_range(-enemy_x_variance,enemy_x_variance)
	
	#TODO: clip the value so it no goes beyond screen
	new_enemy.position += Vector2(x_variance,y_variance)
	
	add_child.call_deferred(new_enemy)

func spawn():
	var min_enemies_local = clamp(min_enemies,0,max_enemies)
	var n = randi_range(min_enemies_local, max_enemies)
	
	var spawns_idx = range(qnt_spawns)
	spawns_idx.shuffle()
	
	for i in range(n):
		var idx = spawns_idx[i]
		spawn_enemy(spawns[idx].position)

func _on_timer_timeout():
	if on:
		spawn()
