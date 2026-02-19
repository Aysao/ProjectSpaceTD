extends CanvasLayer

signal runStart
func _on_play_pressed() -> void:
	runStart.emit()
	visible = false
	pass # Replace with function body.


func _on_quit_pressed() -> void:
	get_tree().quit()
	pass # Replace with function body.
