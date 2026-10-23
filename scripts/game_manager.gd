extends Node

var score: float = 0.0

signal new_score(score: float)

func add_to_score(amount: float):
    score += amount
    new_score.emit(score)
