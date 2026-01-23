extends Node

const MAX_LIFE = 3
const MAX_ENERGY = 10.0
const MIN_ENEGRY = 0.0
const ENERGY_DRAIN_PER_SEC := 2.5

@export var item_scene: PackedScene
@export var hearts_scene: PackedScene
@export var energy_scene: PackedScene

var score = 0
var life: int = MAX_LIFE
var energy: float = MIN_ENEGRY
var running := false

func _ready() -> void:
	$ItemTimer.stop()
	$StartTimer.stop()
	$HeartsTimer.stop()
	$EnergyTimer.stop()
	$Player.set_physics_process(false)
	$HUD.show_start_screen()
	
	$Backgroundmusic.stop()
	
func _process(delta: float) -> void:
	if not running:
		return
	
	var wants_boost := Input.is_action_pressed("move_energy")
	
	if wants_boost and energy > 0.0:
		var was_full := energy >= MAX_ENERGY
		#boost on
		$Player.set_boosted(true)
		
		#use boost
		energy = max(energy - ENERGY_DRAIN_PER_SEC * delta, 0.0)
		
		if was_full and energy < MAX_ENERGY:
			$EnergyTimer.wait_time = randf_range(10.0, 20.0)
		#HUD
		
		#wenn energy leer wird
		if energy <= 0.0:
			$Player.set_boosted(false)
		
	else:
		$Player.set_boosted(false)
		
func _on_hud_start_game():
	new_game()

func new_game():
	running = true
	score = 0
	life = MAX_LIFE
	energy = 5.0
	
	get_tree().call_group("items", "queue_free")
	get_tree().call_group("hearts", "queue_free")
	
	$HUD.update_score(score)
	$HUD.update_lives(life)
	
	$Player.start($StartPosition.position)
	$Player.set_physics_process(true)
	
	$StartTimer.start()
	
	$Backgroundmusic.play()

func game_over():
	running = false
	$ItemTimer.stop()
	$StartTimer.stop()
	$HeartsTimer.stop()
	$EnergyTimer.stop()
	
	$HeartCollect.stop()
	$Player.stop_sounds()
	$HeartLose.stop()
	$Backgroundmusic.stop()
	$DeathSound.play()
	
	get_tree().call_group("items", "queue_free")
	get_tree().call_group("hearts", "queue_free")
	get_tree().call_group("energys", "queue_free")
	
	$Player.set_physics_process(false)
	$HUD.show_game_over()

func _on_item_collected():
	score += 1
	$HUD.update_score(score)
	
	$ItemCollect.play()

func _on_missed_item() ->void:
	life -= 1
	
	$HUD.animate_life_lost(life)
	$HUD.update_lives(life)
	
	$HeartLose.stop()
	$HeartLose.play()
	
	if life <= 0:
		game_over()
		
func _on_hearts_collected() -> void:
	if life > 0 and life < MAX_LIFE:
		life += 1
		$HUD.update_lives(life)
		$HeartCollect.play()

func _on_energy_collected() -> void:
	if energy >= 0 and energy < 10:
		energy += 1.0
		print("energy")
	if energy >= MAX_ENERGY:
		$EnergyTimer.stop()
		
#func 

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
	$EnergyTimer.wait_time = randf_range(5.0, 10.0)
	$EnergyTimer.start()

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

func _on_energy_timer_timeout():
	if not running:
		return
	
	var energys = energy_scene.instantiate()
	energys.add_to_group("energys")
	
	var energys_spawn_location = $ItemPath/ItemSpawnLocation
	energys_spawn_location.progress_ratio = randf()
	energys.position = energys_spawn_location.position
	
	energys.energy_collected.connect(_on_energy_collected)
	
	$EnergyTimer.wait_time = randf_range(10.0, 20.0)
	$EnergyTimer.start()
	
	add_child(energys)
