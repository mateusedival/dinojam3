extends Node
# SIGNALS TO HELP UI
signal score_update(score: int)

var score = 0

func score_updater(update_amount: int):
	score += update_amount
	emit_signal('score_update',score)
	print(score)
