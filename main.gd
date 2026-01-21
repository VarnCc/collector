extends Node

const MAX_LIFE = 3

@export var item_scene: PackedScene
@export var hearts_scene: PackedScene

var score = 0
var life: int = MAX_LIFE
var running := false

func _ready() -> void:
	$ItemTimer.stop()
	$StartTimer.stop()
	$HeartsTimer.stop()
	$Player.set_physics_process(false)
	$HUD.show_start_screen()

func _on_hud_start_game():
	new_game()

func new_game():
	running = true
	score = 0
	life = MAX_LIFE
	
	get_tree().call_group("items", "queue_free")
	
	$HUD.update_score(score)
	$HUD.update_lives(life)
	
	$Player.start($StartPosition.position)
	$Player.set_physics_process(true)
	
	$StartTimer.start()

func game_over():
	running = false
	$ItemTimer.stop()
	$StartTimer.stop()
	$HeartsTimer.stop()
	
	get_tree().call_group("items", "queue_free")
	
	$Player.set_physics_process(false)
	$HUD.show_game_over()

func _on_item_collected():
	score += 1
	$HUD.update_score(score)

func _on_missed_item() ->void:
	life -= 1
	
	$HUD.animate_life_lost(life)
	$HUD.update_lives(life)
	
	if life <= 0:
		game_over()
		
func _on_hearts_collected() -> void:
	if life > 0 and life < MAX_LIFE:
		life += 1
		$HUD.update_lives(life)

func _on_item_timer_timeout():
	if not running:
		return
		
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
	$HeartsTimer.wait_time = randf_range(8.0, 20.0)
	$HeartsTimer.start()

func _on_hearts_timer_timeout():
	if not running:
		return
		
	var hearts = hearts_scene.instantiate()
	hearts.add_to_group("hearts")
	
	var hearts_spawn_location = $ItemPath/ItemSpawnLocation
	hearts_spawn_location.progress_ratio = randf()
	hearts.position = hearts_spawn_location.position
	
	hearts.hearts_collected.connect(_on_hearts_collected)
	
	$HeartsTimer.wait_time = randf_range(8.0, 20.0)
	$HeartsTimer.start()
	
	add_child(hearts)
