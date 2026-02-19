extends StationBase
class_name StationBaseAttackers

@export var damage = 10.0
@export var fire_rate = 1.0
@export var fire_speed = 10.0
@export var bullet_target = 3;
@export var target : Node3D
@export var enemiesInZone := []
@export var effectZoneSize := 100
@export var height := 20
var fire_cooldown : float = fire_rate
var bullet_pool : BulletPool


@onready var effectZone = $EffectZone/CollisionEffectZone

func _on_effect_zone_body_entered(body: Node3D) -> void:
	if(body.is_in_group("enemies")):
		if not target:
			target = body
		enemiesInZone.append(body)
	pass # Replace with function body.


func _on_effect_zone_body_exited(body: Node3D) -> void:
	if(body.is_in_group("enemies")):
		reset_target(body)
	pass # Replace with function body.
	
func reset_target(body : Node3D):
	enemiesInZone.erase(body)
	if body == target:
		if enemiesInZone.size() > 0:
			target = enemiesInZone.back()
		else : 
			target = null
	elif body in enemiesInZone:
		if enemiesInZone.size() > 0 and target == null:
			target = enemiesInZone.back()

func set_bullet_pool(in_bullet_pool: BulletPool):
	bullet_pool = in_bullet_pool

func init():
	init_process()
	set_bullet_pool(get_tree().get_first_node_in_group("bullet_manager"))
	if effectZone.shape == null:
		effectZone.shape = CylinderShape3D.new()
	if(effectZone.shape is CylinderShape3D):
		effectZone.shape = effectZone.shape.duplicate()
		effectZone.shape.radius = effectZoneSize
		effectZone.shape.height = height

func init_process():
	pass
