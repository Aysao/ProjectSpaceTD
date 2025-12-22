extends StationBase
class_name StationBaseAttackers

@export var damage = 10.0
@export var fire_rate = 1.0
@export var fire_speed = 10.0
@export var bullet_target = 3;
@export var target : Node3D
@export var enemiesInZone: Array[Node3D] = []
var fire_cooldown : float = fire_rate
var bullet_pool : BulletPool

func _on_effect_zone_body_entered(body: Node3D) -> void:
	if(body.is_in_group("enemies")):
		target = body
		enemiesInZone.append(target)
		print("enemies arrived %s" % body)
	pass # Replace with function body.


func _on_effect_zone_body_exited(body: Node3D) -> void:
	if(body.is_in_group("enemies")):
		reset_target(body)
		
		print("enemies exited")
	pass # Replace with function body.
	
func reset_target(body : Node3D):
	if body == target:
		enemiesInZone.erase(body)
		if enemiesInZone.size() > 0:
			target = enemiesInZone.pop_back()
		else : 
			target = null

func set_bullet_pool(in_bullet_pool: BulletPool):
	bullet_pool = in_bullet_pool
