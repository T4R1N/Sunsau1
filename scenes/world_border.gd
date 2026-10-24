extends Area2D


func _on_body_entered(body: Node2D) -> void:
	var burrower: BurrowComponent = body.get_node("BurrowComponent")
	if burrower != null:
		burrower.direction = -burrower.direction
