extends RigidBody2D
signal hearts_collected

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$heart.play()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		queue_free()
		hearts_collected.emit()
	elif body.is_in_group("ground"):
		queue_free()
