extends Node

const FadeOut = preload('res://UI/fadeOut.tscn')


@export var LEVEL_TIMER: float = 2 * 60.0
@export var next_scene: String = ''

@export var level_id: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	$LevelTimer.start(LEVEL_TIMER)
	PlayerStats.connect('no_health',_on_level_timer_timeout)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Hud.set_timer(int($LevelTimer.time_left))
	if $LevelTimer.time_left < int(LEVEL_TIMER/2):
		$EnemySpawner.spawn_rate = 1
		$EnemySpawner.min_enemies = 2


func _on_level_timer_timeout():
	Globals.finish_level(level_id)
	var fade_out = FadeOut.instantiate()
	fade_out.connect('finished',change_scene)
	get_tree().root.add_child(fade_out)

func change_scene():
	get_tree().change_scene_to_file(next_scene)
