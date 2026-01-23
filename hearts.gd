extends RigidBody2D
signal hearts_collected

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$heart.play()
