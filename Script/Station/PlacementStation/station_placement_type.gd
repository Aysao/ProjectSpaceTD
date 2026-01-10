extends StationBase
class_name StationBasePlacement

@onready var healthBar = $HealthBar
@onready var progressBar = $HealthBar/SubViewport/ProgressBar
@onready var slotNode = $SlotNode

@export var slotLimit := 0

func init():
	healthBar.visible= true
	progressBar.max_value = max_health
	progressBar.value = current_health
	await get_tree().process_frame
	init_process()
	update_label_position(false,healthBar,Vector3.ZERO)
	connect_all_slot_update_limit()
	pass
	
func reset_all_enemy():
	for enemy in get_tree().get_nodes_in_group("enemies"):
		enemy.set_Target()

func connect_all_slot_update_limit():
	for slot in slotNode.get_children():
		slot.updateLimit.connect(update_limit)

func update_limit():
	var countLimit = 0
	for slot in slotNode.get_children():
		if slot.station and countLimit < slotLimit:
			countLimit += 1
			
	for slot in slotNode.get_children():
		if countLimit >= slotLimit and not slot.station:
			slot.is_disabled = true
		elif countLimit < slotLimit and not slot.station:
			slot.is_disabled = false
		slot.updateShader()
	
	pass
	
func _die():
	for slot in slotNode.get_children():
		if slot.station:
			slot.station._die()
	queue_free()
	pass

func init_process():
	pass
