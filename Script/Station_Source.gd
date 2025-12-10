extends StationBase

signal build_area_entered
signal build_area_exited

func _on_effect_zone_body_entered(body: Node3D) -> void:
	if(body.is_in_group("Player")):
		emit_signal("build_area_entered")
	pass # Replace with function body.


func _on_effect_zone_body_exited(body: Node3D) -> void:
	if(body.is_in_group("Player")):
		emit_signal("build_area_exited")
	pass # Replace with function body.
