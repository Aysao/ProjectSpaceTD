extends StationBasePlacement

var stationSlot_load = preload("res://Scene/Station/station_slot.tscn")
@export var offset = 40.0

func initAnimation():
	init_upgrade_list()
	procedural_line(1)
	#var animIdle = animation.get_animation("idle")
	#animIdle.loop_mode = Animation.LOOP_LINEAR
	#animation.play("idle")


func start_hold():
	pass
	
func stop_hold():
	pass
	
func other_die_effect():
	EventBus.end_of_run.emit()

func init_upgrade_list():
	upgrade_list = {
		"slot": {
			"cost" : "0",
			"name" : "slot",
			"description" : "Ajoute une ligne de slot supplémentaire",
			"available" : true,
			"level" : 1,
			"max_level" : 6
		}
	}
	
func specific_upgrade(key: String):
	if key == "slot":
		if slotLimit < upgrade_list[key]["max_level"] :
			upgrade_list[key]["level"] += 1
			procedural_line(upgrade_list[key]["level"])
			EventBus.connect_all_slot.emit()

func procedural_line(line_number: int):
	var angleNumber = 3*line_number 
	for i in range(angleNumber * 2):
		print(i)
		var stationslot : StationSlot = stationSlot_load.instantiate()
		slotNode.add_child(stationslot)
		stationslot.global_position = Vector3(cos((i*PI)/angleNumber) * (offset * line_number), 0, sin((i*PI)/angleNumber) * (offset * line_number))
		
	pass
