extends Node3D
class_name stationSlot

@onready var slot_mesh := $Area3D/MeshInstance3D
@export var slot_type := StationReference.StationSlotType.DEPLOYER_SLOT
@export var parent : Node3D
var is_disabled := false
var station = null

signal updateLimit()

signal player_near(slot : Node3D)
signal player_far(slot : Node3D)
	

func _ready() -> void:
	shaderParameters()

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player") and not is_disabled:
		player_near.emit(self)
	pass # Replace with function body.


func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.is_in_group("Player") and not is_disabled:
		player_far.emit(self)
	pass # Replace with function body.


func place_station(stationIn : Node3D) -> bool:
	if stationIn.neededSlot == slot_type and not is_disabled:
		station = stationIn
		station.parentSlot = self
		updateLimit.emit()
		return true
	else: 
		return false

func shaderParameters():
	# Créer une copie du material
	if slot_mesh.get_surface_override_material(0):
		slot_mesh.material_override = slot_mesh.get_surface_override_material(0).duplicate()
	else:
		slot_mesh.material_override = StandardMaterial3D.new()
		
	slot_mesh.material_override.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	updateShader()	

func updateShader():
	if is_disabled :
		slot_mesh.material_override.albedo_color = Color(0.5, 0.0, 0.0, 0.5)
	else :
		slot_mesh.material_override.albedo_color = Color(0,0,0.5,0.5)
