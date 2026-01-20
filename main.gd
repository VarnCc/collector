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
	$HUD.show_game_over()

func new_game():
	score = 0
	life = 3
	get_tree().call_group("items", "queue_free")
	$HUD.update_score(score)
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$Player.set_physics_process(true)

func _ready() -> void:
	$ItemTimer.stop()
	$Player.set_physics_process(false)
	$HUD.show_start_screen()

func _on_item_collected():
	score += 1
	$HUD.update_score(score)

func _on_missed_item():
	life -= 1
	if life <= 0:
		game_over()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_item_timer_timeout():
	var item = item_scene.instantiate()
	item.add_to_group("items")
	var item_spawn_location = $ItemPath/ItemSpawnLocation
	item_spawn_location.progress_ratio = randf()
	item.position = item_spawn_location.position
	item.item_collected.connect(_on_item_collected)
	item.missed_item.connect(_on_missed_item)

	add_child(item)


func _on_start_timer_timeout():
	$ItemTimer.start()


func _on_hud_start_game():
	new_game()
