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
	call_deferred("shaderParameters")

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player") and not is_disabled:
		player_near.emit(self)
	pass # Replace with function body.

func _process(delta: float) -> void:
	slot_mesh.material_override.set_shader_parameter("position", global_position)

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
	if slot_mesh.get_active_material(0):
		slot_mesh.material_override = slot_mesh.get_active_material(0).duplicate()
	else:
		slot_mesh.material_override = StandardMaterial3D.new()
	
	await get_tree().process_frame
	updateShader()	

func updateShader():
	slot_mesh.material_override.set_shader_parameter("position", global_position)
	if is_disabled :
		slot_mesh.material_override.set_shader_parameter("wave_color", Color(0.8, 0.8, 0.8, 0.5))
		slot_mesh.material_override.set_shader_parameter("noise_color", Color(0.8, 0.8, 0.8, 0.5))
		slot_mesh.material_override.set_shader_parameter("Activated", false)
	else :
		slot_mesh.material_override.set_shader_parameter("wave_color", Color(0.6, 0.5, 0.90, 0.5))
		slot_mesh.material_override.set_shader_parameter("noise_color", Color(0.6, 0.5, 0.90, 0.5))
		slot_mesh.material_override.set_shader_parameter("Activated", true)
