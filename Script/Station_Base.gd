extends Node3D
class_name StationBase

@export var max_health := 100.0
@export var current_health := 100.0
@export var effectZoneSize := 100
@export var height := 20
@export var bullet_layer = 2;
@export var materialPrice := 0
@export var galaxiumConsumption := 0.0
@export var activated := 1
@export var station_Type := StationReference.StationType.SOURCE
@export var neededAreaToBuild := StationReference.StationType.SOURCE
var parents_station := []
var child_station := []
var inArea := true

var ressourceManager : Node3D
@onready var stationAnimation := $AnimationPlayer
@onready var healthbar = $HealthBar/SubViewport/ProgressBar
@onready var model = $Model
@onready var effectZone = $EffectZone/CollisionEffectZone



#Materials
@export var blueprint_material: ShaderMaterial


signal build_area_entered(stationNode : Node3D)
signal build_area_exited(stationNode : Node3D)

func _ready() -> void:
	update_visual_state()
	if activated == 1 :
		if station_Type == StationReference.StationType.SOURCE or station_Type == StationReference.StationType.DEPLOYER:
			$HealthBar.visible= true
			healthbar.max_value = max_health
			healthbar.value = current_health
			update_label_position(false)
		if effectZone.shape == null:
			effectZone.shape = CylinderShape3D.new()
		if(effectZone.shape is CylinderShape3D):
			effectZone.shape = effectZone.shape.duplicate()
			effectZone.shape.radius = effectZoneSize
			effectZone.shape.height = height
		init()
			
	
	

func take_damage(damage: int) -> void:
	current_health -= damage
	healthbar.value = current_health
	if current_health <= 0:
		_die()


func update_label_position(isCubic : bool):
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

	$HealthBar.position = Vector3(2*width/3, height + 0.5, 0)

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

func _die() :
	for child in child_station :
		child.remove_parent(self)
	for parent in parents_station :
		parent.remove_child_from_parents(self)
	queue_free()

func remove_parent(parent : StationBase):
	if parent in parents_station :
		parents_station.erase(parent)
	
	if parents_station.size() < 1 :
		queue_free()

func remove_child_from_parents(child : StationBase):
	if child in child_station :
		child_station.erase(child)
		
func addChild(child : StationBase):
	child_station.append(child)
	child.addParent(self)

func addParent(parent : StationBase):
	parents_station.append(parent)
	

func _on_effect_zone_body_entered(body: Node3D) -> void:
	
	if(body.is_in_group("Player")):
		emit_signal("build_area_entered", self)
	pass # Replace with function body.


func _on_effect_zone_body_exited(body: Node3D) -> void:
	if(body.is_in_group("Player")):
		emit_signal("build_area_exited", self)
	pass # Replace with function body.

func is_active() -> bool :
	return activated

func initialisation(ressource_manager: Node3D):
	ressourceManager = ressource_manager


func init():
	pass


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
