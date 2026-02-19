extends StationBasePlacement

@onready var animation := $Model/NewSource/AnimationPlayer




func initAnimation():
	init_upgrade_list()
	var animIdle = animation.get_animation("idle")
	animIdle.loop_mode = Animation.LOOP_LINEAR
	animation.play("idle")


func start_hold():
	pass
	
func stop_hold():
	pass
	
func other_die_effect():
	EventBus.end_of_run.emit()

func init_upgrade_list():
	upgrade_list = {
		"slot": {
			"cost" : "2",
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
