extends Label

func _ready() -> void:
	GameManager.connect("new_score", _score_update)

func _score_update(new_score: float) -> void:
	text = "$" + str(new_score)
