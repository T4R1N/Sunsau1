class_name BurrowComponent
extends Node2D

@onready var parent := get_parent()

@export var burrow_timer: Timer
@export var hide_timer: Timer
@export var pause_timer: Timer
@export var burrow_sprite: Sprite2D
@export var revealed_sprite: Sprite2D

@export var score: float = 1.0

@export_category("Burrow Behavior")
@export var burrow_time: float = 4.0
@export var burrow_time_rand: float = 1.5
@export var hide_time: float = 1.0

@export_category("Movement Behavior")
@export var move_time: float = 1.0
@export var pause_time: float = 1.0
@export var speed: float = 200.0

var direction: float = randf_range(0, 360)
var whackable: bool = true

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
	if pause_timer != null:
		pause_timer.connect("timeout", _pause_movement)

func conceal() -> void:
	revealed_sprite.visible = false
	burrow_sprite.visible = true


func begin_burrow() -> void:
	state = BurrowState.Burrowing
	conceal()
	if burrow_timer != null:
		burrow_timer.wait_time = burrow_time + (randf_range(-burrow_time_rand, burrow_time_rand))
		burrow_timer.start()
	if pause_timer != null:
		pause_timer.wait_time = move_time
		pause_timer.start()


func _pop_out() -> void:
	state = BurrowState.Revealed
	revealed_sprite.visible = true
	burrow_sprite.visible = false
	hide_timer.wait_time = hide_time
	hide_timer.start()

func _hide() -> void:
	begin_burrow()

func whack() -> void:
	GameManager.add_to_score(score)
	go_away()

func go_away() -> void:
	get_parent().visible = false
	whackable = false
	await get_tree().create_timer(5.0).timeout
	parent.global_position.x = randf_range(0, get_window().size.x)
	parent.global_position.y = randf_range(0, get_window().size.y)
	parent.visible = true
	whackable = true

func _pause_movement() -> void:
	var original_speed := speed
	speed = 0.0
	await get_tree().create_timer(pause_time).timeout
	direction = randf_range(0, 360)
	speed = original_speed



func _physics_process(delta: float) -> void:
	match state:
		BurrowState.Burrowing:
			var angle := deg_to_rad(direction)
			parent.global_position += Vector2(cos(angle), sin(angle)) * speed * delta
