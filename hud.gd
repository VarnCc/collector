extends CanvasLayer
signal start_game

func update_score(score):
	$Score.text = str(score)
	$Score.show()

func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()

func show_game_over():
	show_message("Game over")
	await $MessageTimer.timeout
	$Control/StartButton.show()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_button_pressed():
	$Control/StartButton.hide()
	show_temporary_message()
	start_game.emit()

func _on_message_timer_timeout():
	$Message.hide()

func new_game() -> void:
	pass # Replace with function body.

func show_start_screen():
	$Control/StartButton.show()

func show_temporary_message():
	$Message.text = "<- A/D ->"
	$Message.show()
	await get_tree().create_timer(2.0).timeout
	$Message.hide()
