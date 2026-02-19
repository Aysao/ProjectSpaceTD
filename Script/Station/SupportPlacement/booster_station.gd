extends Support_base_station

var target = null
@onready var animation := $Model/booster/AnimationPlayer



func init_process():
	init_upgrade_list()
	if not target:
		target = get_tree().get_first_node_in_group("Source") 
	if target:
		look_at(target.global_position, Vector3.UP)

func initAnimation():
	var animIdle = animation.get_animation("idle")
	animIdle.loop_mode = Animation.LOOP_LINEAR
	animation.play("idle")


func init_upgrade_list():
	upgrade_list = {
		"galaxium_rate": {
			"cost" : "2",
			"name" : "Galaxium rate",
			"description" : "Augemente le nombre de galaxium par seconde",
			"value" : 1.5,
			"available" : true,
			"level" : 1,
			"max_level" : 5
		}
	}
	
func specific_upgrade(key: String):
	upgrade_list[key]["level"] += 1
	match key : 
		"galaxium_rate":
			resources_manager.update_galaxium_rate(upgrade_list[key]["value"])
			
		
