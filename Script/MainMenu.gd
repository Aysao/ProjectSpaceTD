extends CanvasLayer

signal runStart
func _on_play_pressed() -> void:
	runStart.emit()
	print("click")
	visible = false
	pass # Replace with function body.
