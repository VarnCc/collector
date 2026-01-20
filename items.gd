extends RigidBody2D
signal item_collected
signal missed_item


# Called when the node enters the scene tree for the first time.
func _ready():
	gravity_scale = randf_range(0.25, 0.6)
	$AnimatedSprite2D.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		queue_free()
		item_collected.emit()
	elif body.is_in_group("ground"):
		queue_free()
		missed_item.emit()
