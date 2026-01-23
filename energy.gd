extends RigidBody2D
signal energy_collect


func _ready() -> void:
	$energy.play()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		queue_free()
		energy_collect.emit()
	elif body.is_in_group("ground"):
		queue_free()
