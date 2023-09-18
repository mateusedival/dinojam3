extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.connect("score_update",set_score)
	PlayerStats.connect('health_changed',set_health)
	PlayerStats.connect('max_health_changed',set_max_health)
	
	
func set_health(health):
	$VBoxContainer/HealthBox/Health.text = str(health)
	
func set_max_health(health):
	$VBoxContainer/HealthBox/Health.text = str(health)


func set_score(score: int):
	$VBoxContainer/ScoreBox/Score.text = str(score)
	
func set_timer(time_in_seconds: int):
	var m = int(time_in_seconds/60)
	var s = time_in_seconds % 60
	
	var m_string = str(m)
	if (m < 10):
		m_string =  "0" + str(m) if m > 0 else "00"
	var s_string = str(s)
	if (s < 10):
		s_string = "0" + str(s) if  s > 0 else "00"
	$Timer.text = m_string + ':' + s_string
