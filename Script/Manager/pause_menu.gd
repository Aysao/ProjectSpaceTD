extends Control
@onready var panel: Panel = $Panel
@onready var run_manager: RunManager = $".."


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		panel.visible = !panel.visible
		get_tree().paused = panel.visible


func _on_back_to_menu_pressed() -> void:
	get_tree().paused = false
	EventBus.back_to_menu.emit()
	pass # Replace with function body.


func _on_quit_pressed() -> void:
	get_tree().quit()
	pass # Replace with function body.


func _on_continue_pressed() -> void:
	panel.visible = !panel.visible
	get_tree().paused = panel.visible
	pass # Replace with function body.
