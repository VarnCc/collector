extends CharacterBody2D
signal hit

const SPEED = 400.0

func _physics_process(delta: float) -> void:


	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
		if direction > 0:
			$AnimatedSprite2D.flip_h = true
		elif direction < 0:
			$AnimatedSprite2D.flip_h = false
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
