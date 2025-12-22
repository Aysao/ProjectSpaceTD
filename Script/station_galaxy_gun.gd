extends StationBaseAttackers

@onready var canon := $Canon
var fire := false

func _process(delta: float) -> void:
	if target == null :
		fire = false
		if enemiesInZone.size() > 0 :
			target = enemiesInZone.get(0)
		elif not $AnimationPlayer.is_playing():
			$AnimationPlayer.play("idle")

	if target and ressourceManager.current_galaxium > 0:
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
			instance.damage = damage
			instance.target=bullet_target
			instance.position=canon.global_position
			instance.transform.basis = canon.global_transform.basis
			instance.direction = (target.global_position - canon.global_position).normalized()
			fire_cooldown = fire_rate
