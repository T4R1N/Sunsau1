class_name Whacker
extends Area2D

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Whack"):
		whack()

func whack() -> void:
	for body in get_overlapping_bodies():
		var burrower = body.get_node("BurrowComponent")
		if burrower != null and burrower.state == burrower.BurrowState.Revealed:
			burrower.whack()

func _physics_process(delta: float) -> void:
	global_position = get_global_mouse_position()
