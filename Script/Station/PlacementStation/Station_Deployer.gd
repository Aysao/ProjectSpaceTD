extends StationBasePlacement

var target = null


func init_process():
	if not target:
		target = get_tree().get_first_node_in_group("Source") 
	if target:
		look_at(target.global_position, Vector3.UP)
		#update_label_position(false,$HealthBar, Vector3.ZERO)
