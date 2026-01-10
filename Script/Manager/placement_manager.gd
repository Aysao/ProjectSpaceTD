# station_placement_manager.gd
extends Node

var preview: Node3D = null
var active_slots: Array[Node3D] = []  # Slots dans lesquels on est
var nearest_slot: Node3D = null

@onready var RessourcesManager := $"../RessourcesManager"
@onready var enemieManagement := $"../EnemiesSpawnMarker"
@onready var stationPreview := $"../GameNode/WorldParameters/station_preview"
@onready var playerItems := $"../GameNode/PlayerItems"

var cooldown_rate = 1.0
var preview_cooldown = 1.0

func _process(delta: float) -> void:
	if preview:
		if preview_cooldown > 0.0 :
			preview_cooldown -= delta
		else :
			if Input.is_action_just_pressed("Shoot"):
				confirm_placement()
			elif Input.is_action_just_pressed("build"): 
				cancel_placement()
		

func start_placement(preview_scene: Node3D):
	if preview:
		return  # Déjà en placement
	
	preview_scene.activated = 0
	preview = preview_scene
	stationPreview.add_child(preview)
	preview_cooldown = cooldown_rate
	preview_scene.stationAnimation.stop()

func _connect_all_slots():
	for slot in get_tree().get_nodes_in_group("Station_slot"):
		if not slot.player_near.is_connected(_on_slot_entered):
			slot.player_near.connect(_on_slot_entered)
		if not slot.player_far.is_connected(_on_slot_exited):
			slot.player_far.connect(_on_slot_exited)

func _on_slot_entered(slot: Node3D):
	if slot.station:
		return
	
	if preview and slot.slot_type == preview.neededSlot:
		active_slots.append(slot)
		_update_snap()

func _on_slot_exited(slot: Node3D):
	if preview and slot.slot_type == preview.neededSlot:
		active_slots.erase(slot)
		_update_snap()

func _update_snap():
	if not preview:
		return
	
	if active_slots.is_empty():
		# Plus de slots à proximité : délock
		stationPreview.unlock_from_slot()
		nearest_slot = null
		return
	
	# Trouve le slot le plus proche
	var player = get_tree().get_first_node_in_group("Player")
	if not player:
		return
	
	var closest = null
	var min_dist = INF
	
	for slot in active_slots:
		var dist = player.global_position.distance_to(slot.global_position)
		if dist < min_dist:
			min_dist = dist
			closest = slot
	
	# Lock sur le plus proche
	if closest != nearest_slot:
		nearest_slot = closest
		stationPreview.lock_to_slot(closest)

func confirm_placement() -> bool:
	if not preview or not nearest_slot:
		return false
	
	# Place la station définitivement
	var station = load(preview.scene_file_path).instantiate()
	playerItems.add_child(station)
	station.global_position = preview.global_position
	
	if nearest_slot.place_station(station):
		RessourcesManager.update_material(-station.materialPrice)
	
		onSpawnStation(station)
		
		cancel_placement()
		return true
	else:
		station.queue_free()
		return false

func cancel_placement():
	if preview:
		preview.queue_free()
		stationPreview.reset()
		preview = null
	nearest_slot = null
	active_slots.clear()

func _on_control_emit_spawn_request(station_name: String) -> void:
	if !preview :
		var station_scene = StationReference.Station_sub_item_definition[station_name]["scene"]
		var instance = load(station_scene).instantiate()
		if RessourcesManager.isEnough(instance.materialPrice) :
			start_placement(instance)
		else :
			instance.queue_free()
	pass # Replace with function body.

func onSpawnStation(station):
	if station.station_Type == StationReference.StationType.DEPLOYER :
		_connect_all_slots()
	elif station.station_Type == StationReference.StationType.ATTACKER :
		enemieManagement.resetTarget.connect(station.reset_target)


func init():
	_connect_all_slots()
	
