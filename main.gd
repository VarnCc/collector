extends Node
@export var item_scene: PackedScene
var score = 0
var life = 3

func start_game():
	score = 0
	life = 3
	$HUD.update_score(score)
	$Player.start($StartPosition.position)
	
func game_over():
	$ItemTimer.stop()
	$Player.set_physics_process(false)


func _ready():
	start_game()

func _on_item_collected():
	score += 1
	$HUD.update_score(score)

func _on_missed_item():
	life -= 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_item_timer_timeout():
	var item = item_scene.instantiate()
	var item_spawn_location = $ItemPath/ItemSpawnLocation
	item_spawn_location.progress_ratio = randf()
	item.position = item_spawn_location.position
	item.item_collected.connect(_on_item_collected)
	item.missed_item.connect(_on_missed_item)
	if life <= 0:
		game_over()

	var velocity = Vector2(randf_range(-30.0, 30.0), 0.0)
	add_child(item)
