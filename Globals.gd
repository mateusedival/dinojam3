extends Node
# SIGNALS TO HELP UI
signal score_update(score: int)

signal level_finished(idx: int)

var score = 0

func score_updater(update_amount: int):
	score += update_amount
	emit_signal('score_update',score)
	print(score)
	
func finish_level(idx: int):
	emit_signal('level_finished',idx)
