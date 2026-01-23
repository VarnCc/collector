extends CharacterBody2D
signal hit

const SPEED = 400.0
const BOOST_MULT := 1.6

var boosted := false
var last_boosted := false

@onready var move_sfx: AudioStreamPlayer2D = $PlayerSound

func _physics_process(delta: float) -> void:
	
	var current_speed := SPEED
	if boosted:
		current_speed *= BOOST_MULT
		if boosted and not last_boosted:
			$BoostUseing.stop()
			$BoostUseing.play()
		
	last_boosted = boosted

	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * current_speed
		if direction > 0:
			$AnimatedSprite2D.flip_h = true
			if not move_sfx.playing:
				move_sfx.play()
		elif direction < 0:
			$AnimatedSprite2D.flip_h = false
			if not move_sfx.playing:
				move_sfx.play()
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if move_sfx.playing:
			move_sfx.stop()

	move_and_slide()
	position.x = clamp(position.x, 25.0, 615.0)
	
func set_boosted(value: bool) ->void:
	boosted = value

func start(pos):
	position = pos
	show()

func stop_sounds():
	if move_sfx.playing:
		move_sfx.stop()
	if $BoostUseing.playing:
		$BoostUseing.stop()
