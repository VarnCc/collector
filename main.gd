extends Node
@export var item_scene: PackedScene

var score = 0

func start():
	score = 0

func _ready():
	start()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_item_timer_timeout():
	var item = item_scene.instantiate()
	var item_spawn_location = $ItemPath/ItemSpawnLocation
	item_spawn_location.progress_ratio = randf()

	item.position = item_spawn_location.position

	var velocity = Vector2(randf_range(-30.0, 30.0), 0.0)
	
	add_child(item)
