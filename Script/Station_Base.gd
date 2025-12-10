extends Node3D
class_name StationBase

@export var max_health := 100
@export var current_health := 100
@export var effectZoneSize := 100
@export var height := 20
@export var bullet_layer = 2;
@export var galaxium_price := 0
@export var activated := 1


@onready var healthLabel = $HealthLabel
@onready var model = $Model
@onready var effectZone = $EffectZone/CollisionEffectZone


func _ready() -> void:
	if activated == 1:
		healthLabel.text = String.num_scientific(current_health)
		if effectZone.shape == null:
			effectZone.shape = CylinderShape3D.new()
		if(effectZone.shape is CylinderShape3D):
			effectZone.shape = effectZone.shape.duplicate()
			effectZone.shape.radius = effectZoneSize
			effectZone.shape.height = height
		pass # Replace with function body.

func take_damage(damage: int) -> void:
	current_health -= damage
	healthLabel.text = String.num_scientific(current_health)
	if current_health <= 0:
		queue_free()


func update_label_position():
	if not model or not healthLabel:
		return

	# Récupère la taille réelle du modèle
	var aabb = get_model_aabb(model)
	var height = aabb.size.y

	# Place le label juste au-dessus
	healthLabel.position = Vector3(0, height + 0.5, 0)


func get_model_aabb(node: Node) -> AABB:
	var aabb := AABB()
	var found := false

	if node is MeshInstance3D:
		aabb = node.get_mesh().get_aabb()
		found = true

	for child in node.get_children():
		if child is MeshInstance3D:
			if not found:
				aabb = child.get_mesh().get_aabb()
				found = true
			else:
				aabb = aabb.merge(child.get_mesh().get_aabb())

	return aabb
