extends Control


func _ready() -> void:
	call_deferred("setup")

func setup():
	EventBus.end_of_run.connect(_on_end_of_game)

func _on_end_of_game():
	get_tree().paused = true
	visible = true
	mouse_filter = Control.MOUSE_FILTER_STOP
	


func _on_replay_button_pressed() -> void:
	get_tree().paused = false
	EventBus.replay.emit()
	pass # Replace with function body.


func _on_back_to_menu_pressed() -> void:
	get_tree().paused = false
	EventBus.back_to_menu.emit()
	pass # Replace with function body.
