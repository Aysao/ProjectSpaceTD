extends StationBasePlacement

var target = null

func init_process():
	init_upgrade_list()
	if not target:
		target = get_tree().get_first_node_in_group("Source") 
	if target:
		look_at(target.global_position, Vector3.UP)
		#update_label_position(false,$HealthBar, Vector3.ZERO)


func init_upgrade_list():
	upgrade_list = {
		"slot": {
			"cost" : "0",
			"name" : "slot",
			"description" : "Ajoute un emplacement de station",
			"available" : true,
			"level" : 1,
			"max_level" : 6
		}
	}
	
func specific_upgrade(key: String):
	if key == "slot":
		if slotLimit < upgrade_list[key]["max_level"] :
			slotLimit += 1
			upgrade_list[key]["level"] += 1
			update_limit()
