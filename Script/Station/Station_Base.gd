extends Node3D
class_name StationBase

@export var max_health := 100.0
@export var current_health := 100.0
@export var bullet_layer = 2;
@export var materialPrice := 0
@export var galaxiumConsumption := 0.0
@export var activated := 1
@export var station_Type := StationReference.StationType.SOURCE
@export var neededSlot := StationReference.StationSlotType.DEPLOYER_SLOT


var is_holding := false
var playerInArea := false
var parentSlot : Node3D

var ressourceManager : Node3D
@onready var stationAnimation := $AnimationPlayer
@onready var healthbar = $HealthBar/SubViewport/ProgressBar
@onready var model = $Model

#Upgrade mecanique 
@export var upgradeWeight := 0.0
@export var upgradingConsumption := 0
@export var upgradeCount := 0

#Materials
@export var blueprint_material: ShaderMaterial

#input utils
@onready var hold_input_cooldown := $Timer

signal build_area_entered(stationNode : Node3D)
signal build_area_exited(stationNode : Node3D)

signal in_InteractionZone(in_interactionZone : Node3D)

func _ready() -> void:
	update_visual_state()
	if activated == 1 :
		ressourceManager = get_tree().get_first_node_in_group("ressource_Manager")
		init()
		initAnimation()
			

func take_damage(damage: int) -> void:
	current_health -= damage
	healthbar.value = current_health
	if current_health <= 0:
		_die()

func _die():
	queue_free()
	if parentSlot:
		print("in parentSlot")
		parentSlot.station = null
		parentSlot.parent.update_limit()
	pass

func update_label_position(isCubic : bool, node_to_place : Node3D, offset : Vector3):
	if not model or not healthbar:
		return

	# Récupère la taille réelle du modèle
	var aabb = get_model_aabb(model)
	var height = 0
	var width = 0
	if isCubic:
		height = aabb.size.y if aabb.size.y > aabb.size.x else aabb.size.x
		width = aabb.size.y if aabb.size.y > aabb.size.x else aabb.size.x
	else :
		height = aabb.size.y
		width = aabb.size.x

	node_to_place.global_position = global_position + Vector3(1.25*width, height+5, 0)
	node_to_place.global_rotation = Vector3.ZERO
	
func get_model_aabb(node: Node) -> AABB:
	var aabb := AABB()
	var model := node.get_child(0)
	for child in model.get_children():
		if child is MeshInstance3D:
			var temp = child.get_mesh().get_aabb()
			if aabb.size.y < temp.size.y : 
				aabb.size.y = temp.size.y
			if aabb.size.x < temp.size.x : 
				aabb.size.x = temp.size.x
	return aabb

func is_active() -> bool :
	return activated

func update_visual_state():
	if activated == 0:
		apply_blueprint_material(model)
	elif activated == 1:
		remove_blueprint_material(model)

func apply_blueprint_material(node: Node):
	if node is MeshInstance3D:
		node.material_override = blueprint_material

	for child in node.get_children():
		apply_blueprint_material(child)


func remove_blueprint_material(node: Node):
	if node is MeshInstance3D:
		node.material_override = null

	for child in node.get_children():
		remove_blueprint_material(child)
		


func _on_interaction_zone_body_entered(body: Node3D) -> void:
	if(activated):
		if body.is_in_group("Player"):
			body.focusOn = self
			body.in_interact_area = true
			playerInArea = true
			$Interaction.visible = true
		pass # Replace with function body.


func _on_interaction_zone_body_exited(body: Node3D) -> void:
	if activated :
		if body.is_in_group("Player"):
			body.in_interact_area = false
			playerInArea = false
			$Interaction.visible = false
			stop_hold()
		pass # Replace with function body.

func _input(event: InputEvent) -> void:
	if playerInArea and event.is_action_pressed("build"):
		start_hold()
	if event.is_action_released("build"):
		stop_hold()


func start_hold():
	is_holding = true
	hold_input_cooldown.start(2.0)
	
func stop_hold():
	is_holding = false
	hold_input_cooldown.stop()
	pass

func init():
	pass

func initAnimation():
	pass


func _on_timer_timeout() -> void:
	if playerInArea and is_holding:
		_die()
		ressourceManager.update_material(materialPrice/2)
	pass # Replace with function body.
