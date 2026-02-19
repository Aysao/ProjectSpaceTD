extends StationBaseAttackers

@onready var canon := $Canon
var fire := false

func _process(delta: float) -> void:
	if target == null or not target.activated:
		fire = false
		if not $AnimationPlayer.is_playing():
			$AnimationPlayer.play("idle")

	if target and target.activated and resources_manager.current_galaxium > 0:
		# regarde vers le prism
		if $AnimationPlayer.is_playing() && !fire:
			$AnimationPlayer.stop()
		look_at(target.global_position, Vector3.UP)
		
		if fire_cooldown > 0.0:
			fire_cooldown -= delta
		
		if fire_cooldown <= 0.0:
			$AnimationPlayer.stop()
			$AnimationPlayer.play("fire")
			fire = true
			
			var instance = bullet_pool.get_player_bullet()
			if instance != null:
				instance.init_station_bullet(self,target)
				instance.damage = damage
				instance.target=bullet_target
				instance.position=canon.global_position
				instance.transform.basis = canon.global_transform.basis
				instance.direction = (target.global_position - canon.global_position).normalized()
				fire_cooldown = fire_rate
			
func init_process():
	init_upgrade_list()
	pass

func init_upgrade_list():
	upgrade_list = {
		"damage": {
			"cost" : "1",
			"name" : "Damage",
			"description" : "Ajoute 10 de dégats à la station",
			"available" : true,
			"value" : 10,
			"consumption_value" : 0.20,
			"level" : 1,
			"max_level" : 5
		},
		"fire_rate": {
			"cost" : "1",
			"name" : "Fire rate",
			"description" : "Augmente la vitesse de tir de la station",
			"available" : true,
			"value": 0.20,
			"consumption_value" : 0.20,
			"level" : 1,
			"max_level" : 3
		}
	}
	
func specific_upgrade(key: String):
	match key :
		"damage":
			damage += upgrade_list[key]["value"]
			galaxiumConsumption += upgrade_list[key]["consumption_value"]
		"fire_rate":
			if fire_rate - upgrade_list[key]["value"] > 0:
				fire_rate -= upgrade_list[key]["value"]
				galaxiumConsumption += upgrade_list[key]["consumption_value"]
	upgrade_list[key]["level"] += 1
	resources_manager.update_galaxium_rate(- upgrade_list[key]["consumption_value"])
		
