extends CanvasLayer

signal runStart
func _on_play_pressed() -> void:
	runStart.emit()
	visible = false
	pass # Replace with function body.
