class_name BurrowComponent
extends Node2D

@export var burrow_timer: Timer
@export var hide_timer: Timer
@export var burrow_sprite: Sprite2D
@export var revealed_sprite: Sprite2D

@export_category("Burrow Behavior")
@export var burrow_time: float = 4.0
@export var burrow_time_rand: float = 1.5
@export var hide_time: float = 0.5

enum BurrowState {
	Burrowing,
	Revealed,
	Whacked
}

var state: BurrowState = BurrowState.Burrowing

func _ready() -> void:
	begin_burrow()
	if hide_timer != null:
		hide_timer.connect("timeout", _hide)
	if burrow_timer != null:
		burrow_timer.connect("timeout", _pop_out)

func conceal() -> void:
	revealed_sprite.visible = false
	burrow_sprite.visible = true


func begin_burrow() -> void:
	state = BurrowState.Burrowing
	conceal()
	if burrow_timer != null:
		burrow_timer.wait_time = burrow_time + (randf_range(-burrow_time_rand, burrow_time_rand))
		burrow_timer.start()

func _pop_out() -> void:
	state = BurrowState.Revealed
	revealed_sprite.visible = true
	burrow_sprite.visible = false
	hide_timer.wait_time = hide_time
	hide_timer.start()

func _hide() -> void:
	conceal()

func whack() -> void:
	queue_free()
